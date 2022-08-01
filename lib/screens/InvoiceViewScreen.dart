import 'dart:convert';
import 'package:flutter/material.dart';
import '/widgets/invoice/InvoiceTaxinfo.dart';
import '../widgets/invoice/InvoiceOrderWidget.dart';
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
  List<Invoice> invoice = [];
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
    final int id = ModalRoute.of(context)?.settings.arguments as int;
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
    });
    setState(() {
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
            appBar: AppBar(
              backgroundColor: Theme.of(context).cardColor,
              title: Text(
                invoice.isNotEmpty ? 'Rechnung ${invoice[0].id}' : 'Rechnung',
                style: const TextStyle(color: Color(0xFF2C3333)),
              ),
              iconTheme: const IconThemeData(
                  color: Color(0xFF2C3333),
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 5),
                child: ListView(
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
                                  invoice.isNotEmpty
                                      ? invoice[0].id.toString()
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
                              invoice.isNotEmpty
                                  ? invoice[0].date.substring(11, 16)
                                  : '?',
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF2C3333),
                                fontSize: 20,
                              ),
                            ),
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
                    Column(children: [
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
                              invoice.length > 0
                                  ? invoice[0].amount.toString()
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
                    ]),
                  ],
                ),
              ),
            ),
          );
  }

  Future<void> getRestaurant() async {
    //callling the restaurant info Api
    final url = Uri.parse('https://www.inspery.com/app/api/restaurant/3');
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
      'https://www.inspery.com/invoice/invoices_items/$id',
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
      'https://www.inspery.com/invoice/$id',
    );
    final headers1 = {
      "Content-type": "application/json",
      'Authorization': 'Token $token',
    };
    final response1 = await http.get(url1, headers: headers1);

    if (response1.statusCode == 200) {
      final data = Map<String, dynamic>.from(jsonDecode(response1.body));
      var o = Invoice.fromJson(data);
      List<Invoice> invoice = [o];
      setItems(items, invoice);
    } else {
      print(
          'Request failed with status: ${response.statusCode}. /invoice/invoices_items/$id/');
      print(response.reasonPhrase);
    }
  }
}
