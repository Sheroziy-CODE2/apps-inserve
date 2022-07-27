import 'dart:io';
import 'dart:typed_data';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import '../Models/InvoiceItemsDictModel.dart';
import '/Providers/TableItemProvidor.dart';
import '/printer/ConfigPrinter.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import '../Models/CheckoutModel.dart';
import '../Models/TableModel.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:path_provider/path_provider.dart';

import '../main.dart';
import 'Authy.dart';
import 'package:intl/intl.dart';

class Tables with ChangeNotifier {
  final List<TableModel> _items = [];

  IOWebSocketChannel? _allTableschannel;
  final streamController = StreamController.broadcast();
  String? token;

  final ConfigPrinter _configPrinter = ConfigPrinter();

  double sliderValue = 0.0;

  // Tables(this.token);
  List<TableModel> get items {
    return [..._items];
  }

  update(String t) {
    token = t;
  }

  notify() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => notifyListeners());
  }

  //write to app path, this belongs to the printer
  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  bool isItemFromWaiter({required int tableID}) {
    var tableItems = findById(tableID).tIP.tableItems;
    for (var element in tableItems) {
      if (element.fromWaiter) return true;
    }
    return false;
  }

  Future<void> checkoutItemsToSocket(
      {required context, required int tableID, bool reload = false}) async {
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
        "selected_price": elements[i].selected_price,
        "side_products": elements[i].side_product,
        "added_ingredients": elements[i].added_ingredients,
        "deleted_ingredients": elements[i].deleted_ingredients,
      };
      jsonElemnts.add(j);
    }
    print("## Package to send: ");
    print(jsonElemnts);
    for (int i = 0; i < elements.length; i++) {
      findById(tableID).tIP.delete(elements[i]);
    }
    for (int i = 0; i < jsonElemnts.length; i++) {
      if (jsonElemnts[i]["quantity"] == 0) {
        jsonElemnts.removeAt(i);
      }
    }
    if (reload) {
      findById(tableID).tIP.notify();
      return;
    }
    table.channel.sink.add(
        jsonEncode({"command": "new_table_items", "table_items": jsonElemnts}));
    try{
      notify();
    }catch(e){};
  }

  Future<void> transferTableToAnotherUserSocket(
      {required String newUserID, required List tableIDs}) async {
    _allTableschannel?.sink.add(jsonEncode({
      "command": "transfer_tables",
      "new_user": newUserID,
      "tables": tableIDs
    }));
  }

  Future<void> transferAllItemsToSocket(
      {required context, required int tableID, required int newTableID}) async {
    //Looking for the old tableID to transfer its items to the new one
    var table = findById(tableID);

    table.channel.sink.add(jsonEncode(
        {"command": "transfer_all_table_items", "new_table": newTableID}));
  }

  Future<void> checkout({required context, required int tableID}) async {
    var table = findById(tableID);
    final totalPrice = table.tIP.getTotalCartTablePrice(context: context)!;
    double cash = 0.0;
    double card = 0.0;
    String tipType = "cash";

    var element = table.tIP.tableItems;
    List<InvoiceItemsDictModelItems> itemsList = [];
    for (int x = 0; x < element.length; x++) {
      if (element[x].getInCard() < 1) continue;
      // add items to the payment list
      itemsList.add(InvoiceItemsDictModelItems(quantity: element[x].getInCard(), order: element[x].id));
    }

    if (itemsList.isEmpty) {
      try {
        final _context = MyApp.navKey.currentContext;
        if (_context != null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 1),
            backgroundColor: Colors.orange,
            content: Text("Kein Produkt gewählt"),
          ));
          return;
        }
      } catch (e) {
        print("CurrentContext error: " + e.toString());
        return;
      }
    }

    final Map<int, String> paymentOptions = {0: "Bar", 1: "Mix", 2: "Karte"};
    final Map<int, String> paymentImages = {
      0: "assets/images/PayCash.png",
      1: "assets/images/PayCardCash.png",
      2: "assets/images/PayCard.png",
    };
    final Map<int, Icon> paymentIcons = {
      0: Icon(Icons.monetization_on_outlined,
          color: Colors.black.withOpacity(0.6)),
      1: Icon(Icons.multiple_stop_outlined,
          color: Colors.black.withOpacity(0.6)),
      2: Icon(Icons.credit_card, color: Colors.black.withOpacity(0.6))
    };
    double tip = 0;
    bool onEnd = true; //so that it reset first time
    double sliderMin = 0;
    double sliderMax = 0;
    sliderValue = totalPrice;
    double tipSize = 0.5;
    if (totalPrice > 100) {
      tipSize = 5;
    }
    if (totalPrice > 1000) {
      tipSize = 50;
    }
    cash = tip;
    card = totalPrice;
    double stepsize = 1.25;
    if ((totalPrice) < 10) {
      // runden auf 0.5€
    } else if ((totalPrice) < 50) {
      // runden auf 1€
      stepsize = 2.5;
    } else if ((totalPrice) < 100) {
      // runden auf 5€
      stepsize = 12.5;
    } else if ((totalPrice) < 500) {
      // runden auf 10€
      stepsize = 25;
    } else {
      // runden auf 25€
      stepsize = 62.5;
    }

    showDialog(
      context: context,
      builder: (context) {
        int paymentMethod = 0;
        return StatefulBuilder(
          builder: (context2, state) {
            if (onEnd) {
              if(tipType == "cash" && sliderMin < tip){
                sliderMin = tip;
              }
              if(tipType == "card" && sliderMax > (totalPrice-tip)){
                sliderMax = (totalPrice-tip);
              }

              sliderMin = sliderValue - stepsize;
              if (sliderMin < 0) sliderMin = 0;
              sliderMax = sliderValue + stepsize;

              if (sliderMax > (totalPrice + tip)) {
                sliderMax = (totalPrice + tip);
                sliderMin = sliderMax - (2 * stepsize);
              }
              onEnd = false;
              if(sliderValue > sliderMax){
                sliderValue = sliderMax;
              }
              // print("SliderValue: " +
              //     sliderValue.toStringAsFixed(1) +
              //     " Min: " +
              //     sliderMin.toStringAsFixed(1) +
              //     " Max: " +
              //     sliderMax.toStringAsFixed(1) +
              //     " Delta: " +
              //     (stepsize * 2).toStringAsFixed(1));
            }
            return AlertDialog(
              backgroundColor: const Color(0xFFF5F2E7),
              //title: const Text("Zahlungsmethode wählen"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(paymentImages[paymentMethod]!),
                  Center(
                    child: Container(
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text("Rechnung"),
                            Text(
                              totalPrice.toStringAsFixed(2) + "€",
                              style: const TextStyle(
                                fontSize: 20,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text("Trinkgeld"),
                            Text(
                              tip.toStringAsFixed(2) + "€",
                              style: const TextStyle(
                                fontSize: 20,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text("Gesamt"),
                            Text(
                                (totalPrice+tip).toStringAsFixed(2) + "€",
                              style: const TextStyle(
                                fontSize: 20,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F2E7),
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                    width: 110,
                                    height: 35,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, left: 5, right: 5),
                                      child: Stack(
                                        children: [
                                          const SizedBox(
                                              width: 100,
                                              child: Text(
                                                "Fix",
                                                style: TextStyle(fontSize: 15),
                                                textAlign: TextAlign.center,
                                              )),
                                          Positioned(
                                              left: 0,
                                              child: GestureDetector(
                                                onTap: () {
                                                  tip -= tipSize;
                                                  if (tip < 0) tip = 0;
                                                  cash = tip;
                                                  card = totalPrice;
                                                  state(() {});
                                                },
                                                child: const SizedBox(
                                                  width: 50,
                                                  height: 35,
                                                  child: Text(
                                                    "-",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              )),
                                          Positioned(
                                              left: 50,
                                              child: GestureDetector(
                                                onTap: () {
                                                  tip += tipSize;
                                                  cash = tip;
                                                  card = totalPrice;
                                                  state(() {});
                                                },
                                                child: const SizedBox(
                                                  width: 50,
                                                  height: 35,
                                                  child: Text(
                                                    "+",
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F2E7),
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                    width: 110,
                                    height: 35,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, left: 5, right: 5),
                                      child: Stack(
                                        children: [
                                          const SizedBox(
                                              width: 100,
                                              child: Text(
                                                "Runden",
                                                style: TextStyle(fontSize: 15),
                                                textAlign: TextAlign.center,
                                              )),
                                          Positioned(
                                              left: 0,
                                              child: GestureDetector(
                                                onTap: () {
                                                  tip = ((totalPrice + tip - tipSize) * (1 / tipSize)).roundToDouble() * tipSize - totalPrice;
                                                  if (tip < 0) tip = 0;
                                                  cash = tip;
                                                  card = totalPrice;
                                                  state(() {});
                                                },
                                                child: const SizedBox(
                                                  width: 50,
                                                  height: 35,
                                                  child: Text(
                                                    "-",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              )),
                                          Positioned(
                                              left: 50,
                                              child: GestureDetector(
                                                onTap: () {
                                                  tip = ((totalPrice +
                                                                      tip +
                                                                      tipSize) *
                                                                  (1 / tipSize))
                                                              .roundToDouble() *
                                                          tipSize -
                                                      totalPrice;
                                                  cash = tip;
                                                  card = totalPrice;
                                                  state(() {});
                                                },
                                                child: const SizedBox(
                                                  width: 50,
                                                  height: 35,
                                                  child: Text(
                                                    "+",
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SliderTheme(
                    data: const SliderThemeData(
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
                      inactiveTrackColor: Color(0xFFF5F2E7),
                      activeTrackColor: Color(0xFFF5F2E7),
                      thumbColor: Colors.green,
                      overlayColor: Color(0xFFFFFFFF),
                      activeTickMarkColor: Colors.black,
                      inactiveTickMarkColor: Colors.black,
                    ),
                    child: Visibility(
                      visible: paymentMethod == 1,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          GestureDetector(
                            onTap: (){
                              state(() {
                                if(cash < tip){
                                  cash = tip;
                                  card = totalPrice;
                                  sliderMax = card;
                                }
                                tipType = "cash";
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    border: tipType == "cash"
                                        ? Border.all(
                                        color: Colors.green,
                                        width: 1) : null ),
                                width: 62,
                                child: Column(
                                  children: [
                                    const Text(
                                      "Bar",
                                      style: TextStyle(fontSize: 11),
                                    ),
                                    cash >= 1000
                                        ? Text(cash.toStringAsFixed(0))
                                        : Text(cash.toStringAsFixed(2)),
                                  ],
                                )),
                          ),
                          Expanded(
                            child: Slider(
                              value: sliderValue,
                              min: sliderMin,
                              max: sliderMax,
                              divisions: 4, //(sliderMax-sliderMin).round()*2,
                              label: (sliderValue / (totalPrice + tip) * 100)
                                      .toStringAsFixed(0) +
                                  "%",
                              onChangeEnd: (value) {
                                state(() {
                                  onEnd = true;
                                });
                              },
                              onChanged: (double value) {
                                state(() {
                                  sliderValue = value;
                                  if (sliderValue > sliderMax) {
                                    sliderValue = (sliderMax - 0.5).roundToDouble();
                                  }
                                  if (sliderValue < sliderMin) {
                                    sliderValue = (sliderMin + 0.5).roundToDouble();
                                  }
                                  if ((totalPrice) < 10) {
                                    // runden auf 0.5€
                                    cash = ((sliderValue - 0.26) * 2)
                                            .roundToDouble() / 2;
                                  } else if ((totalPrice) < 50) {
                                    // runden auf 1€
                                    cash = (sliderValue - 0.51).roundToDouble();
                                  } else if ((totalPrice) < 100) {
                                    // runden auf 5€
                                    cash = ((sliderValue - 2.6) * 0.2).roundToDouble() / 0.2;
                                  } else if ((totalPrice) < 500) {
                                    // runden auf 10€
                                    cash = ((sliderValue - 5.1) * 0.1).roundToDouble() / 0.1;
                                  } else {
                                    // runden auf 25€
                                    cash = (sliderValue * 0.04).roundToDouble() / 0.04 - 25;
                                  }
                                  if(tipType == "card" && sliderValue > cash){
                                    cash = sliderValue;
                                  }
                                  if (cash < 0) cash = 0;


                                  if(card < tip && tipType == "card"){
                                    card = tip;
                                    cash = totalPrice;
                                    sliderMax = cash;
                                    sliderMin = sliderMax - (stepsize*2);
                                    if(sliderMin < 0) sliderMin = cash;
                                  }
                                  if(cash < tip && tipType == "cash"){
                                    cash = tip;
                                    card = totalPrice;
                                    sliderMin = cash;
                                    sliderMax = sliderMin + (stepsize*2);
                                    if(sliderMax > card) sliderMax = card;
                                  }
                                  if(sliderValue > sliderMax){
                                    sliderValue = sliderMax;
                                  }
                                  if(sliderValue < sliderMin){
                                    sliderValue = sliderMin;
                                  }
                                  card = (totalPrice + tip) - cash;
                                });
                              },
                            ),
                          ),
                    GestureDetector(
                      onTap: (){
                        state(() {
                          if(card < tip){
                            card = tip;
                            if(card < tip && tipType == "card"){
                              card = tip;
                              cash = totalPrice;
                              sliderMax = cash;
                              sliderMin = sliderMax - (stepsize*2);
                              if(sliderMin < 0) sliderMin = cash;
                            }
                            if(cash < tip && tipType == "cash"){
                              cash = tip;
                              card = totalPrice;
                              sliderMin = cash;
                              sliderMax = sliderMin + (stepsize*2);
                              if(sliderMax > card) sliderMax = card;
                            }
                            if(sliderValue > sliderMax){
                              sliderValue = sliderMax;
                            }
                            if(sliderValue < sliderMin){
                              sliderValue = sliderMin;
                            }
                          }
                          tipType = "card";
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(10),
                              border: tipType == "card"
                                  ?  Border.all(
                                  color: Colors.green,
                                  width: 1) : null),
                          width: 62,
                          child: Column(
                                children: [
                                  const Text(
                                    "Karte",
                                    style: TextStyle(fontSize: 11),
                                  ),
                                  Text(card.toStringAsFixed(2)),
                                ],
                              ),
                      ),
                    ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: paymentOptions.keys
                          .map(
                            (key) => Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    state(() {
                                      paymentMethod = key;
                                    });
                                  },
                                  child: SizedBox(
                                      height: 40,
                                      width: 90,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 2,
                                            left: 2,
                                            child: Container(
                                              height: 34,
                                              width: 83,
                                              padding: const EdgeInsets.only(
                                                  left: 35, right: 7),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: paymentMethod != key
                                                      ? null
                                                      : Border.all(
                                                          color: Colors.green,
                                                          style:
                                                              BorderStyle.solid,
                                                          width: 4)),
                                              child: Center(
                                                  child: Text(
                                                paymentOptions[key]!,
                                                style: const TextStyle(
                                                    fontSize: 11),
                                              )),
                                            ),
                                          ),
                                          Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE8E8E8),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: paymentIcons[key],
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          )
                          .toList()),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      List<InvoiceItemsDictModelPayments> payments = [];
                      switch(paymentMethod){
                        case 0:
                          tipType = "cash";
                          payments.add(InvoiceItemsDictModelPayments(type: "cash", price: (totalPrice*100).round()/100));
                          break;
                        case 2:
                          tipType = "card";
                          payments.add(InvoiceItemsDictModelPayments(type: "card", price: (totalPrice*100).round()/100));
                          break;
                        default:
                          if(tipType == "cash") {
                            payments.add(InvoiceItemsDictModelPayments(type: "card", price: (card*100).round()/100));
                            payments.add(InvoiceItemsDictModelPayments(type: "cash", price: ((cash-tip)*100).round()/100));
                          }
                          if(tipType == "card") {
                            payments.add(InvoiceItemsDictModelPayments(type: "card", price: ((card-tip)*100).round()/100));
                            payments.add(InvoiceItemsDictModelPayments(type: "cash", price: (cash*100).round()/100));
                          }
                          break;
                      }
                      Navigator.of(context).pop();
                      checkout_print(
                          invoiceItemDictModel:
                          InvoiceItemDictModel(
                              tip: (tip*100).round()/100,
                              tableID: tableID,
                              items: itemsList,
                              payments: payments,
                              tipType: tipType
                          )
                      );
                    },
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: const Center(child: Text("Rechnung drucken")),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> showCalculator({required context, required double amount}) {
    return showDialog(
      context: context,
      builder: (context) {
        String typedInValue = "0000,00€";
        int actPos = 0;
        final List<double> block = [7, 8, 9, 4, 5, 6, 1, 2, 3, -1, 0, -1];
        List<bool> isPressed = List.generate(block.length, (index) => false);

        return StatefulBuilder(
          builder: (context2, setState) {
            double rueckgeld = double.parse(
                    typedInValue.replaceFirst(",", ".").replaceFirst("€", "")) -
                amount;
            if (rueckgeld < 0) rueckgeld = 0;
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
                                  Text(
                                    amount.toStringAsFixed(2) + "€",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text("Vom Kunde Gezahlt"),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: List.generate(
                                    typedInValue.length,
                                    (index) => Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            typedInValue[index],
                                            style: TextStyle(
                                                color: index == actPos
                                                    ? Colors.green
                                                    : Colors.black,
                                                fontSize: 30,
                                                fontWeight: index == actPos
                                                    ? FontWeight.bold
                                                    : FontWeight.normal),
                                          ),
                                        )),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text("Rückgeld"),
                              Text(
                                rueckgeld
                                        .toStringAsFixed(2)
                                        .replaceFirst(".", ",") +
                                    "€",
                                style: const TextStyle(
                                    fontSize: 25,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold),
                              ),
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
                        children: List.generate(
                            block.length,
                            (index) => block[index] == -1
                                ? Container()
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        typedInValue = typedInValue.substring(
                                                0, actPos) +
                                            block[index].toStringAsFixed(0) +
                                            typedInValue.substring(actPos + 1);
                                        actPos++;
                                        if (actPos == typedInValue.length - 1)
                                          actPos = 0;
                                        if (typedInValue[actPos] == ",")
                                          actPos++;
                                        if (typedInValue[actPos] == "€")
                                          actPos++;
                                        isPressed[index] = true;
                                      });
                                      Future.delayed(
                                          const Duration(milliseconds: 100),
                                          () => setState(() {
                                                isPressed[index] = false;
                                              }));
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: const Color(0xFFF5F2E7),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 10,
                                              offset: const Offset(-5, -5),
                                              color: Colors.white,
                                              blurStyle: isPressed[index]
                                                  ? BlurStyle.outer
                                                  : BlurStyle.inner,
                                            ),
                                            BoxShadow(
                                              blurRadius: 10,
                                              offset: const Offset(5, 5),
                                              color: const Color(0xFFA7A9AF),
                                              blurStyle: isPressed[index]
                                                  ? BlurStyle.outer
                                                  : BlurStyle.inner,
                                            ),
                                          ]),
                                      child: Center(
                                          child: Text(
                                        block[index].toStringAsFixed(0),
                                        style: const TextStyle(fontSize: 20),
                                      )),
                                    ),
                                  ))),
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

  Future<void> checkout_print({required InvoiceItemDictModel invoiceItemDictModel}) async {
    final _context = MyApp.navKey.currentContext;
    if (_context == null) {
      print("Global context in checkState Tables checkout_printer is null");
      return;
    }

    String token = Provider.of<Authy>(_context, listen: false).token;
    final url = Uri.parse(
      'https://www.inspery.com/invoice/invoices_items/',
    );
    final headers = {
      "Content-type": "application/json",
      "Authorization": "Token ${token}"
    };
    var data = invoiceItemDictModel.getJson();
    print("Json Data to send: " + data);
    final response = await http.post(url, headers: headers, body: data);
    if (response.statusCode == 201) {
      print("Tables Bill Response: " + jsonDecode(response.body).toString());
      CheckoutModel checkoutModel =
          CheckoutModel.fromJson(jsonDecode(response.body), _context);

      print("connection " + (await _configPrinter.checkState()).toString());

      BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

      //var now = DateTime.now();
      //var formatter = DateFormat('HH:mm dd-MM-yyyy');
      //String formattedDate = formatter.format(now);
      //String restaurantPhoto = Provider.of<Authy>(context, listen: false).RestaurantPhotoLink;

      const filename = 'yourlogo.png';
      //var bytes = await rootBundle.load(restaurantPhoto);
      String dir = (await getApplicationDocumentsDirectory()).path;
      //writeToFile(bytes, '$dir/$filename');
      String pathImage = '$dir/$filename';

      bluetooth.isConnected.then((isConnected) {
        if (isConnected ?? false) {
          bluetooth.printCustom("INSPERY", 2, 1);
          bluetooth.printImage(pathImage);
          bluetooth.printNewLine();
          bluetooth.printCustom(
              "Rechnung/Bon-Nr: " + checkoutModel.id.toString(), 0, 2);
          bluetooth.printCustom(DateFormat('hh:mm dd-MM-yyy').format(checkoutModel.dateTime),
              0,
              2);
          bluetooth.printCustom(
              "Tisch: " + checkoutModel.tableID.toString(), 0, 2);
          bluetooth.printNewLine();

          //List<Map> items = (jsonDecode(jsonReturn["invoice_items"]) as List<dynamic>).cast<Map>();
          for (var item in checkoutModel.invoiceItemList) {
            bluetooth.print4Column(item.quantity.toString(), item.order.product, "",item.amount.toStringAsFixed(2), 1, format: "%2s %15s %5s %5s %n");
            if(item.order.price_description.isNotEmpty) {
              bluetooth.print4Column("", "","", item.order.price_description, 0);
            }
            for (var element in item.order.side_products) {
              bluetooth.print4Column("", "","", element, 0);
            }
            for (var element in item.order.dips) {
              bluetooth.print4Column("", "","", element, 0);
            }
            for (var element in item.order.added_ingredients) {
              bluetooth.print4Column("", "","", element, 0);
            }
            for (var element in item.order.deleted_ingredients) {
              bluetooth.print4Column("", "","", element, 0);
            }
          }
        }

        bluetooth.printCustom("--------------------------------", 1, 0);
        bluetooth.printLeftRight("SUMME", checkoutModel.amount.toStringAsFixed(2) + "EUR", 3);
        bluetooth.printCustom("--------------------------------", 1, 0);
        bluetooth.printCustom("Zahlungsmethode", 0, 2);
        for (var element in invoiceItemDictModel.payments) {
          String method = element.type;
          if(method == "cash") method = "Bar";
          if(method == "card") method = "Karte";
          bluetooth.printCustom(method + ": " + element.price.toStringAsFixed(2), 0, 2);
        };
        bluetooth.printQRcode("https://www.inspery.com/", 150, 150, 1);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.paperCut();
      });

      double cash = 0;
      invoiceItemDictModel.payments.where((element) => element.type == "cash").forEach((element) {
        cash += element.price;
      });

      if (cash > 0) {
        showCalculator(
          context: _context,
          amount: cash,
        );
      }
    } else {
      print(
          'Request failed with status: ${response.statusCode}. invoice/invoices_items/');
      print(
          'Request failed with status: ${response.body}. invoice/invoices_items/');
    }
  }

  //Connect to the new Tables socket
  Future<void> connectALlTablesSocket(
      {required context, required token}) async {
    // if there is no connection yet connect the channel
    print('ws://inspery.com/ws/restaurant_tables/?=$token');
    sleep(const Duration(milliseconds: 300));
    _allTableschannel == null
        ? _allTableschannel = IOWebSocketChannel.connect(
            Uri.parse('ws://inspery.com/ws/restaurant_tables/?=$token'),
          )
        : null;
  }

  Future<void> listenToAllTabelsSocket(
      {required context, required token}) async {
    _allTableschannel?.stream.listen(
      // listen to the updates from the channel
      (message) {
        var data = jsonDecode(message);
        //print(data);
        switch (data['type']) {
          case 'fetch_tables':
            //print(data);
            break;
          case 'transfered_tables':
            for (var i = 0;
                i < data['transfered_tables']["transfered_tables"].length;
                i++) {
              var table =
                  findById(data['transfered_tables']["transfered_tables"][i]);
              table.owner = data['transfered_tables']["owner"];
            }
            notifyListeners();
            break;
        }
      },
      onError: (error) => {
        connectALlTablesSocket(context: context, token: token).then((_) {
          listenToAllTabelsSocket(context: context, token: token);
          print(error);
        }),
      },
    );
    //fetch the table items
    _allTableschannel?.sink.add(jsonEncode({"command": "fetch_tables"}));
  }

  Future<void> connectSocket(
      {required id, required context, required token}) async {
    // if there is no connection yet connect the channel
    print('ws://inspery.com/ws/restaurant_tables/${id}/?=${token}');
    //sleep(const Duration(milliseconds: 300));
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
                _items[i].timeHistory["Buchung"] =
                    _items[i].tIP.getTimeFromLastInputProduct();
                _items[i].timeHistory["Syncronisierung"] =
                    (DateTime.now().millisecondsSinceEpoch / 1000).round();
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
                _items[i].timeHistory["Buchung"] =
                    (DateTime.now().millisecondsSinceEpoch / 1000).round();
                notifyListeners();
                break;

              case 'deleted_table_items':
                //if the type is deleted_table_items the app has to delete this items
                var jsonResponse = data['deleted_table_items'];
                for (var responseItems in jsonResponse) {
                  this._items[i].tIP.deleteItemsFromServer(
                      amount: responseItems['quantity'],
                      itemID: responseItems['id']);
                }
                _items[i].timeHistory["Loeschung"] =
                    (DateTime.now().millisecondsSinceEpoch / 1000).round();
                //notify();
                notifyListeners();
                break;

              case 'transfer_table_items':
                List<int> products = data['transfer'];
                var newTable = data['new_table'];
                _items[i].tIP.transfereTableItem(
                    newTable: newTable, products: products, context: context);
                _items[i].timeHistory["Tischumbuchung"] =
                    (DateTime.now().millisecondsSinceEpoch / 1000).round();
                notifyListeners();
                break;

              //Response from command that read transfer of all items from one table to another.
              case 'transfer_all':
                var table = findById(data['transfer_all']['old_table']['id']);
                table.total_price =
                    data['transfer_all']['old_table']['total_price'];
                List allItemsTable = table.tIP.tableItems;
                table.tIP.delete_items();
                var newTable =
                    findById(data['transfer_all']['new_table']['id']);
                newTable.tIP.add_items(allItemsTable);
                newTable.total_price =
                    data['transfer_all']['new_table']['total_price'];
                //_items[i].timeHistory["Tischumbuchung"] = (DateTime.now().millisecondsSinceEpoch/1000).round();
                notifyListeners();
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
      final data = List<Map<String, dynamic>>.from(
          jsonDecode(utf8.decode(response.bodyBytes)));
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
