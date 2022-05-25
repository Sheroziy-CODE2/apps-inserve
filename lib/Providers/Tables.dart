import 'dart:io';
import 'dart:typed_data';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:inspery_pos/Providers/TableItemProvidor.dart';
import 'package:inspery_pos/printer/ConfigPrinter.dart';
import 'package:inspery_pos/printer/Testprint.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../Models/TableModel.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../main.dart';
import 'Authy.dart';
import 'Ingredients.dart';
import 'Prices.dart';
import 'Products.dart';
import 'SideDishes.dart';

class Tables with ChangeNotifier {
  List<TableModel> _items = [];
  String? token;

  final ConfigPrinter _configPrinter = ConfigPrinter();

  // Tables(this.token);
  List<TableModel> get items {
    return [..._items];
  }

  update(String t) {
    token = t;
  }

  notify() {
    notifyListeners();
  }

  //write to app path, this belongs to the printer
  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<void> checkoutItemsToSocket(
      {required context, required int tableID}) async {
    var table = findById(tableID);
    var tableItems = findById(tableID).tIP.tableItems;
    List<TableItemProvidor> elements =
    tableItems.where((element) => element.fromWaiter == true).toList();
    List jsonElemnts = [];
    for (int i = 0; i < elements.length; i++) {
      var j = {
        "quantity": elements[i].quantity,
        "table": tableID,
        "product": elements[i].product,
        "price": elements[i].price,
        "side_dish": [],
        // elements[i].side_dish
        "added_ingredients": elements[i].added_ingredients,
        "deleted_ingredients": elements[i].deleted_ingredients,
      };
      jsonElemnts.add(j);
    }
    for (int i = 0; i < elements.length; i++) {
      findById(tableID).tIP.delete(elements[i]);
    }
    for (int i = 0; i < jsonElemnts.length; i++) {
      if (jsonElemnts[i]["quantity"] == 0) {
        jsonElemnts.removeAt(i);
      }
    }
    if (jsonElemnts.isEmpty) {
      findById(tableID).tIP.notify(context: context);
      return;
    }
    final WebSocketSink socket = table.channel?.sink;
    socket.add(
        jsonEncode({"command": "new_table_items", "table_items": jsonElemnts}));
    findById(tableID).tIP.notify(context: context);
  }

  Future<void> checkout({required context, required int tableID}) async {
    var table = findById(tableID);
    final totalPrice = table
        .tIP
        .getTotalCartTablePrice(context: context)!;
    if(totalPrice <= 0){
      return;
    }

    final Map<int,String> paymentOptions = {
      0 : "Karte",
      1 : "Bar"
    };
    final Map<int,String> paymentImages = {
      0 : "assets/images/PayCard.png",
      1 : "assets/images/PayCash.png"
    };
    final Map<int,Icon> paymentIcons = {
      0 : Icon(Icons.credit_card,color: Colors.black.withOpacity(0.6)),
      1 : Icon(Icons.monetization_on_outlined,color: Colors.black.withOpacity(0.6))
    };
    showDialog(
      context: context,
      builder: (context) {
        int paymentMethod = 0;
        return StatefulBuilder(
          builder: (context2, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFFF5F2E7),
              //title: const Text("Zahlungsmethode wählen"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(table.name, style: const TextStyle(fontSize: 20,decoration: TextDecoration.underline,),),
                            ),
                            const SizedBox(height: 30,),
                            const Text("Die Rechnung"),
                            Text(totalPrice.toStringAsFixed(2) + "€", style: const TextStyle(fontSize: 20,decoration: TextDecoration.underline,),),
                            const SizedBox(height: 10,),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Image.asset(paymentImages[paymentMethod]!),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                      checkout_print(context: context, tableID: tableID, payment: paymentOptions[paymentMethod]!);
                    },
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: const Center(child: Text("Ja")),
                    ),
                  ),
                  const SizedBox(height: 40,),
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: paymentOptions.keys.map((key) =>
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    paymentMethod = key;
                                  });
                                },
                                child:
                                SizedBox(
                                    height: 40,
                                    width: 127,
                                    child:  Stack(
                                      children: [
                                        Positioned(
                                          top: 2,
                                          left: 2,
                                          child: Container(
                                            height: 34,
                                            width: 120,
                                            padding: const EdgeInsets.only(left: 45, right: 15),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(20),
                                                border: paymentMethod != key ? null : Border.all(color: Colors.green, style: BorderStyle.solid, width: 4)

                                            ),
                                            child: Center(child: Text(paymentOptions[key]!)),
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE8E8E8),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: paymentIcons[key],
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                      ).toList()
                  )
                ],
              ),
            );
          },
        );
      },
    );

  }

  Future<void> showCalculator({required context,required double amount}){
    return showDialog(
      context: context,
      builder: (context) {
        String typedInValue = "0000,00€";
        int actPos = 0;
        final List<double> block = [7,8,9,4,5,6,1,2,3,-1,0,-1];
        List<bool> isPressed = List.generate(block.length, (index) => false);

        return StatefulBuilder(
          builder: (context2, setState) {
            double rueckgeld = double.parse(typedInValue.replaceFirst(",", ".").replaceFirst("€", "")) - amount;
            if(rueckgeld < 0) rueckgeld = 0;
            return AlertDialog(
              backgroundColor: const Color(0xFFF5F2E7),
              content: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Spacer(),
                  Center(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Zu bezahlen:  "),
                                  Text(amount.toStringAsFixed(2) + "€", style: const TextStyle(fontSize: 20,decoration: TextDecoration.underline,),),
                                ],
                              ),
                              const SizedBox(height: 20,),
                              const Text("Vom Kunde Gezahlt"),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: List.generate(typedInValue.length, (index) =>
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                        typedInValue[index],style:
                                      TextStyle(
                                          color: index == actPos ? Colors.green : Colors.black,
                                          fontSize: 30,
                                          fontWeight: index == actPos ? FontWeight.bold : FontWeight.normal
                                      ),
                                      ),
                                    )
                                ),
                              ),
                              const SizedBox(height: 15,),
                              const Text("Rückgeld"),
                              Text(rueckgeld.toStringAsFixed(2).replaceFirst(".", ",") + "€",
                                style: const TextStyle(fontSize: 25,decoration: TextDecoration.underline, fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 280,
                    height: 370,
                    child: GridView.count(
                        physics: const ScrollPhysics(),
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        padding: const EdgeInsets.all(15),
                        shrinkWrap: false,
                        crossAxisCount: 3,
                        children:
                        List.generate(block.length, (index) =>
                        block[index] == -1 ? Container() :
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              typedInValue = typedInValue.substring(0,actPos) + block[index].toStringAsFixed(0) + typedInValue.substring(actPos+1);
                              actPos ++;
                              if(actPos == typedInValue.length-1) actPos = 0;
                              if(typedInValue[actPos] == ",") actPos++;
                              if(typedInValue[actPos] == "€") actPos++;
                              isPressed[index] = true;
                            });
                            Future.delayed(const Duration(milliseconds: 100), () => setState((){isPressed[index] = false;}));
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color(0xFFF5F2E7),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    offset: const Offset(-5,-5),
                                    color: Colors.white,
                                    blurStyle: isPressed[index] ? BlurStyle.outer : BlurStyle.inner,
                                  ),
                                  BoxShadow(
                                    blurRadius: 10,
                                    offset: const Offset(5,5),
                                    color: const Color(0xFFA7A9AF),
                                    blurStyle: isPressed[index] ? BlurStyle.outer : BlurStyle.inner,
                                  ),
                                ]
                            ),
                            child: Center(child: Text(block[index].toStringAsFixed(0), style: const TextStyle(fontSize: 20),)),
                          ),
                        )
                        )

                    ),
                  ),

                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Schließen'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }




  Future<void> checkout_print({required context, required int tableID, required String payment}) async {
    var element = findById(tableID).tIP.tableItems;
    List jsonList = [];
    for (int x = 0; x < element.length; x++) {
      if (element[x].getInCard() < 1) continue;
      // add items to the payment list
      jsonList.add({
        "quantity": element[x].getInCard(),
        "order": element[x].id,
      });
    }
    if(jsonList.isEmpty){
      try {
        final _context = MyApp.navKey.currentContext;
        if(_context!=null){
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.orange,
                content: Text("Kein Produkt gewählt"),)
          );
        }
      }catch(e){
        print("CurrentContext error: " + e.toString());
      }
      return;
    }

    String token = Provider.of<Authy>(context, listen: false).token;
    final url = Uri.parse(
      'https://www.inspery.com/invoice/invoices_items/',
    );
    final headers = {
      "Content-type": "application/json",
      "Authorization": "Token ${token}"
    };
    var data = jsonEncode({
      "table": tableID,
      "payment_type": payment,
      "items": jsonList,
    });
    final response = await http.post(url, headers: headers, body: data);
    if (response.statusCode == 201) {
      print("Response: " + jsonDecode(response.body));




      print("connection " + (await _configPrinter.checkState(context: context).toString()));

      BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

      var now = DateTime.now();
      var formatter = DateFormat('HH:mm dd-MM-yyyy');
      String formattedDate = formatter.format(now);
      String restaurantPhoto =
          Provider.of<Authy>(context, listen: false).RestaurantPhotoLink;

      var ingredientsProvidor = Provider.of<Ingredients>(context, listen: false);
      var priceProvidor = Provider.of<Prices>(context, listen: false);
      var sideDishProvidor = Provider.of<SideDishes>(context, listen: false);
      var productsProvidor = Provider.of<Products>(context, listen: false);

      const filename = 'yourlogo.png';
      //var bytes = await rootBundle.load(restaurantPhoto);
      String dir = (await getApplicationDocumentsDirectory()).path;
      //writeToFile(bytes, '$dir/$filename');
      String pathImage = '$dir/$filename';

      bluetooth.isConnected.then((isConnected) {
        if (isConnected ?? false) {
          bluetooth.printCustom("INSPARY", 2, 1);
          bluetooth.printImage(pathImage);
          bluetooth.printNewLine();
          bluetooth.printCustom("Rechnung/Bon-Nr:13", 0, 2);
          bluetooth.printCustom(formattedDate, 0, 2);
          bluetooth.printNewLine();
          for (int x = 0; x < element.length; x++) {
            if (element[x].getInCard() < 1) continue;
            bluetooth.print4Column(
                element[x].getInCard().toString(),
                productsProvidor.findById(element[x].product).name,
                priceProvidor.findById(element[x].price).price.toStringAsFixed(2),
                element[x].getTotalPrice(context: context).toStringAsFixed(2),
                1,
                format: "%2s %15s %5s %5s %n");

            List<int> sideDishes = element[x].side_dish;
            Map<int, int> sd_map = {};
            sideDishes.forEach((sd) {
              if (!sd_map.containsKey(sd)) {
                sd_map[sd] = 1;
              } else {
                sd_map[sd] = sd_map[sd] ?? 0 + 1;
              }
            });
            sd_map.keys.forEach((id) {
              bluetooth.print4Column(
                  sd_map[id].toString(),
                  sideDishProvidor.findById(id).name,
                  sideDishProvidor
                      .findById(id)
                      .secondary_price
                      .toStringAsFixed(2),
                  "",
                  0,
                  format: "%1s %20s %5s %5s %n");
            });

            List<int> added_ingredients = element[x].added_ingredients;
            Map<int, int> ai_map = {};
            added_ingredients.forEach((sd) {
              if (!ai_map.containsKey(sd)) {
                ai_map[sd] = 1;
              } else {
                ai_map[sd] = ai_map[sd] ?? 0 + 1;
              }
            });
            ai_map.keys.forEach((id) {
              bluetooth.print4Column(
                  ai_map[id].toString(),
                  ingredientsProvidor.findById(id).name,
                  ingredientsProvidor.findById(id).price.toStringAsFixed(2),
                  "",
                  0,
                  format: "%1s %20s %5s %5s %n");
            });
          }
          bluetooth.printCustom("--------------------------------", 1, 0);
          bluetooth.printLeftRight(
              "SUMME",
              findById(tableID)
                  .tIP
                  .getTotalCartTablePrice(context: context)!
                  .toStringAsFixed(2),
              3);
          bluetooth.printCustom("--------------------------------", 1, 0);
          bluetooth.printQRcode("https://www.inspery.com/", 150, 150, 1);
          bluetooth.printNewLine();
          bluetooth.printNewLine();
          bluetooth.printNewLine();
          bluetooth.paperCut();
        }
      });


      if(payment == "Bar") {
        showCalculator(
            context: context,
            amount: findById(tableID).tIP.getTotalCartTablePrice(context: context)!,
        );
      }

    } else {
      print(
          'Request failed with status: ${response.statusCode}. invoice/invoices_items/');
      print(
          'Request failed with status: ${response.body}. invoice/invoices_items/');
    }



  }

  Future<void> connectSocket(
      {required id, required context, required token}) async {
    // if there is no connection yet connect the channel
    var table = findById(id);
    print('ws://inspery.com/ws/restaurant_tables/${id}/?=${token}');
    sleep(const Duration(milliseconds: 300));
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].id == id) {
        await _items[i].channel == null
            ? _items[i].channel = IOWebSocketChannel.connect(
          Uri.parse(
              'ws://inspery.com/ws/restaurant_tables/${id}/?=${token}'),
        )
            : null;
      }
    }
  }

  Future<void> listenSocket(
      {required id, required context, required token}) async {
    var table = findById(id);
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].id == id) {
        _items[i].channel?.stream.listen(
          // listen to the updates from the channel
              (message) {
            var data = jsonDecode(message);
            switch (data['type']) {
              case 'fetch_table_items':
              //if the type is fetch the app has to make a new list of table_items and delete the old one
                this._items[i].total_price =
                data['table']["total_price"].toDouble() as double;
                List<TableItemProvidor> _tIPItems = [];
                var jsonResponse = data['table_items'] as List<dynamic>;
                for (var body in jsonResponse) {
                  _tIPItems.add(TableItemProvidor.fromResponse(body));
                  _tIPItems.last.fromWaiter =
                  false; //Set it to false, because it comes from the server
                }
                this._items[i].tIP.setItems(_tIPItems);
                // notifyListeners();
                _items[i].timeHistory["Buchung"] = _items[i].tIP.getTimeFromLastInputProduct();
                _items[i].timeHistory["Syncronisierung"] = (DateTime.now().millisecondsSinceEpoch/1000).round();
                break;

              case 'table_items':
              //if the type is table_items the app has add the new items to the list of table_items
                var jsonResponse = data['table_items']['table_items'];
                List<TableItemProvidor> _tIPItems = [];
                for (var body in jsonResponse) {
                  // print(TableItemProvidor.fromResponse(body));
                  _tIPItems.add(TableItemProvidor.fromResponse(body));
                }
                this._items[i].tIP.addItemsFromServer(_tIPItems);
                this._items[i].total_price =
                data['table_items']['table']['total_price'].toDouble()
                as double;
                _items[i].timeHistory["Buchung"] = (DateTime.now().millisecondsSinceEpoch/1000).round();
                notifyListeners();
                break;

              case 'deleted_table_items':
              //if the type is deleted_table_items the app has to delete this items
                var jsonResponse = data['deleted_table_items']['invoice_items'];
                for (var body in jsonDecode(jsonResponse)) {
                  this._items[i].tIP.deleteItemsFromServer(
                      body['fields']['quantity'], body['fields']['order']);
                }
                _items[i].timeHistory["Loeschung"] = (DateTime.now().millisecondsSinceEpoch/1000).round();
                break;

              case 'transfer_table_items':
                List<int> products = data['transfer'];
                var newTable = data['new_table'];
                _items[i].tIP.transfereTableItem(newTable: newTable, products: products, context: context);
                _items[i].timeHistory["Tischumbuchung"] = (DateTime.now().millisecondsSinceEpoch/1000).round();
                break;

              default:
                print("Unexpected data['type']: " + data['type']);
                break;
            }
          },
          onError: (error) => {
            connectSocket(id: id, context: context, token: token).then((_) {
              listenSocket(id: id, context: context, token: token);
              print(error);
            }),
          },
        );
        //fetch the table items
        table.channel?.sink.add(jsonEncode({"command": "fetch_table_items"}));
      }
    }
  }

  void fetchTable({required id}) {
    var table = findById(id);
    table.channel?.sink.add(jsonEncode({"command": "fetch_table_items"}));
  }

  Future<void> addTabl({required token}) async {
    // _items.add()

    final url = Uri.parse(
      'https://www.inspery.com/table/tablels',
    );
    final headers = {
      "Content-type": "application/json",
      "Authorization": "Token ${token}"
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      for (int i = 0; i < data.length; i++) {
        var o = TableModel.fromJson(data[i]);
        _items.add(o);
      }
    } else {
      print(
          'Request failed with status: ${response.statusCode}. table/api/tablels');
      print('Request failed with status: ${response.body}. table/api/tablels');
    }
    notifyListeners();
  }

  TableModel findById(int id) {
    // to find a table by ID
    return _items.firstWhere((t) => t.id == id,
        orElse: () => TableModel(
            id: 0, name: '0', owner: 0, total_price: 0.0, type: '0'));
  }

  TableModel findByName(String name) {
    // to find a table by name
    return _items.firstWhere((t) => t.name == name,
        orElse: () => TableModel(
            id: 0, name: '0', owner: 0, total_price: 0.0, type: '0'));
  }
}
