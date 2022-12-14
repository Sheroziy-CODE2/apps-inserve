import 'dart:convert';
import 'package:flutter/material.dart';
import '../Style/PageRoute/CustomPageRoutBuilder.dart';
import '../util/EnvironmentVariables.dart';
import '../widgets/dartPackages/another_flushbar/flushbar.dart';
import '/widgets/invoice/InvoiceTaxinfo.dart';
import '../widgets/invoice/InvoiceOrderWidget.dart';
import 'InvoicesViewScreen.dart';
import 'SplashScreen.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../Providers/Authy.dart';
import '../Models/Invoice.dart';
import '../Models/InvoiceItem.dart';
import '../widgets/reusable/InvoiceSeparator.dart';
import '../widgets/invoice/InvoiceRestaurantInfo.dart';
import 'dart:convert' as convert;

class InvoiceView extends StatefulWidget {
  static const routeName = '/invoce_screen';

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  var _isLoading = true;
  List<InvoiceItem> invoiceItems = [];
  Function? deleteFunction;
  Invoice? invoice;
  String address = '';
  String plz = '';
  String stadt = 'Berlin';
  String phone = '';
  String img = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // get all the invoices
    setState(() {
      _isLoading = true;
    });
    List<Object?> ax = ModalRoute.of(context)?.settings.arguments as List;
    final int id = ax[0] as int;
    deleteFunction = ax[1] as Function;
    final tokenData = Provider.of<Authy>(context);
    String token = tokenData.token;
    getRestaurant();

    addInvoiceItems(token, id);
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  void setItems(items, invoice1) {
    setState(() {
      invoiceItems = items;
      invoice = invoice1;
    });
  }

  void setRestaurantInfo(a, p, ph, i) {
    setState(() {
      address = a;
      plz = p;
      phone = ph;
      img = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    // calculate the size of InvoiceItemsWidget
    int IIWidgetSize = invoiceItems.length;
    for (int i = 0; i < invoiceItems.length; i++) {
      IIWidgetSize += invoiceItems[i].side_products.length;
      IIWidgetSize += invoiceItems[i].deleted_ingredients.length;
      IIWidgetSize += invoiceItems[i].added_ingredients.length;
    }
    IIWidgetSize *= 34;
    return _isLoading == true
        ? const SplashScreen()
        : Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      //bottomNavigationBar:

      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 4,
                    offset: Offset(0, 5), // Shadow position
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        CustomPageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => InvoicesView()),
                      );
                    },
                    child: const SizedBox(
                      width: 50,
                      child: Center(
                        child: Icon(Icons.arrow_back_ios, color: Color(0xFF2C3333),),
                      ),
                    ),
                  ),
                  Text(
                    invoice != null ? 'Rechnung ${invoice!.id}' : 'Rechnung',
                    style: const TextStyle(color: Color(0xFF2C3333), fontSize: 20),
                  ),
                  const SizedBox(width: 50,),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height-172,
              child:
              SingleChildScrollView(
                child:  Column(
                  children: [
                    InvoiceRestaurantInfo(
                        address: address,
                        plz: plz,
                        stadt: stadt,
                        phone: phone,
                        img: img),
                    Container(
                      padding: const EdgeInsets.only(right: 10, bottom: 0),
                      margin: const EdgeInsets.only(bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Material(
                        type: MaterialType.transparency,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(
                                  'Rechnung / Bon-Nr.: ' ' ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF2C3333),
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  invoice != null
                                      ? invoice!.id.toString()
                                      : '?',
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF2C3333),
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              invoice != null
                                  ? invoice!.date.substring(11, 16)
                                  : '?',
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF2C3333),
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 5,)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: IIWidgetSize.toDouble(),
                      child: MediaQuery(
                        data: MediaQuery.of(context).removePadding(
                          removeLeft: false,
                          removeTop: true,
                          removeRight: false,
                          removeBottom: false,
                        ),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: invoiceItems.length,
                          itemBuilder: (context, index) => InvoiceOrderWidget(
                              invoiceItem: invoiceItems[index]),
                        ),
                      ),
                    ),
                    Column(
                        children: [
                          const InvoiceSeparator(color: Color(0xFF2C3333)),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Material(
                              type: MaterialType.transparency,
                              child: Row(children: [
                                const Expanded(
                                  flex: 8,
                                  child: Text(
                                    'Summe',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF2C3333),
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                                Text(
                                  invoice != null
                                      ? invoice!.amount.toString() + " EUR"
                                      : '',
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF2C3333),
                                    fontSize: 25,
                                  ),
                                )
                              ]),
                            ),
                          ),
                          const InvoiceSeparator(color: Color(0xFF2C3333)),
                          const InvoicetaxInfo(),
                        ]
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 125,
                      child: GestureDetector(
                        onTap: () {
                          var alert = AlertDialog(
                            title: const Text("Rechnung Stornieren"),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Abbrechen'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  print("Stornieren " + invoice!.id.toString());
                                  String token = Provider.of<Authy>(context, listen: false).token;
                                  final url = Uri.parse(
                                    EnvironmentVariables.apiUrl+'invoice/delete/' + invoice!.id.toString(),
                                  );
                                  final headers = {
                                    "Content-type": "application/json",
                                    "Authorization": "Token ${token}",
                                  };
                                  final response = await http.delete(url, headers: headers);
                                  if (response.statusCode == 200) {
                                    Navigator.of(context).pop();
                                    deleteFunction!(id: invoice!.id);
                                    Flushbar(
                                      message: "Storniert",
                                      icon: const Icon(
                                        Icons.cancel_presentation_rounded,
                                        size: 28.0,
                                        color: Colors.green,
                                      ),
                                      margin: const EdgeInsets.all(8),
                                      borderRadius: BorderRadius.circular(8),
                                      duration: const Duration(seconds: 4),
                                    ).show(context);
                                  } else {
                                    Flushbar(
                                      message: "Storno nicht m??glich..",
                                      icon: Icon(
                                        Icons.lock,
                                        size: 28.0,
                                        color: Colors.blue[300],
                                      ),
                                      margin: const EdgeInsets.all(8),
                                      borderRadius: BorderRadius.circular(8),
                                      duration: const Duration(seconds: 4),
                                    ).show(context);
                                    print(
                                        'Request failed with status: ${response.statusCode}. invoice/delete/');
                                    print(
                                        'Request failed with status: ${response.body}. invoice/delete/');
                                  }

                                },
                              ),
                            ],
                          );
                          // show the dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color:
                                    const Color(0xFFF3F3F3),
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.assignment_return_outlined,
                                    color: Colors.black
                                        .withOpacity(0.4),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text("Stornieren"),
                              ],
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      width: 105,
                      child: GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color:
                                    const Color(0xFFF3F3F3),
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.print_outlined,
                                    color: Colors.black
                                        .withOpacity(0.4),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text("Beleg"),
                              ],
                            )),
                      ),
                    ),

                    SizedBox(
                      height: 40,
                      width: 105,
                      child: GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color:
                                    const Color(0xFFF3F3F3),
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.print,
                                    color: Colors.black
                                        .withOpacity(0.4),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text("Drucken"),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getRestaurant() async {
    //callling the restaurant info Api
    final url = Uri.parse(EnvironmentVariables.apiUrl+'app/api/restaurant/3');
    try {
      final response = await http.get(url);
      var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
      setRestaurantInfo(jsonResponse[0]['address'], jsonResponse[0]['PLZ'],
          jsonResponse[0]['phone'], jsonResponse[0]['logo']);
    } catch (e) {
      print('error : ${e}, getRestaurant API');
    }
  }

  Future<void> addInvoiceItems(token, id) async {
    //callling the invoiceItems Api
    final url = Uri.parse(
      EnvironmentVariables.apiUrl+'invoice/invoices_items/$id',
    );
    final headers = {
      "Content-type": "application/json",
      'Authorization': 'Token $token',
    };
    final response = await http.get(url, headers: headers);
    List<InvoiceItem> items = [];

    if (response.statusCode == 200) {
      final data = List<Map<String, dynamic>>.from(
          jsonDecode(utf8.decode(response.bodyBytes)));
      for (int i = 0; i < data.length; i++) {
        var o = InvoiceItem.fromJson(data[i]);
        items.add(o);
      }
    } else {
      print(
          'Request failed with status: ${response.statusCode}. /invoice/invoices_items/$id/');
      print(response.reasonPhrase);
    }
    //callling the invoice Api
    final url1 = Uri.parse(
      EnvironmentVariables.apiUrl+'invoice/$id',
    );
    final headers1 = {
      "Content-type": "application/json",
      'Authorization': 'Token $token',
    };
    final response1 = await http.get(url1, headers: headers1);

    if (response1.statusCode == 200) {
      final data = Map<String, dynamic>.from(jsonDecode(response1.body));
      Invoice invoice = Invoice.fromJson(data);
      setItems(items, invoice);
    } else {
      print(
          ' Request failed with status: ${response1.statusCode}. /invoice/$id/');
      print(response1.reasonPhrase);
      print(response1.body);
    }
  }
}
