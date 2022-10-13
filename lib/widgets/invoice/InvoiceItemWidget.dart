import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'dart:io';

import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../../Providers/Authy.dart';
import '../../Models/Invoice.dart';

import '../../screens/InvoiceViewScreen.dart';
import '../../components/TableNameComponent.dart';

class InvoiceItemWidget extends StatefulWidget {
  // this is the invoice item widget the will be shown in the InvoicesViewScreen
  late final int id;
  Function deleteInvoice;
  InvoiceItemWidget({
    required this.id,
    required this.deleteInvoice,
  });

  @override
  State<InvoiceItemWidget> createState() => _InvoiceCardState();
}

class _InvoiceCardState extends State<InvoiceItemWidget> {
  var invoiceDetails = Invoice(
    id: 0,
    date: '',
    amount: 0,
    table: 0,
  );
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final tokenData = Provider.of<Authy>(context);
    String token = tokenData.token;
    invoiceCall(token);
    super.didChangeDependencies();
  }

  Future<void> invoiceCall(String token) async {
    final url = Uri.parse(
      'https://www.inspery.com/invoice/${widget.id}/',
    );
    final headers = {
      "Content-type": "application/json",
      'Authorization': 'Token $token',
    };
    try {
      final response = await http.get(url, headers: headers);
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      // throw an error
      if (jsonResponse.keys.contains('non_field_errors')) {
        throw HttpException(jsonResponse['non_field_errors'][0]);
      } else {
        setState(() {
          invoiceDetails = Invoice(
            id: jsonResponse["id"],
            date: jsonResponse["date"],
            amount: jsonResponse["amount"],
            table: jsonResponse["table"],
          );
        });
      }
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    String date = '';
    if (invoiceDetails.date.length > 0) {
      date = invoiceDetails.date.substring(11, 13) +
          ' ' +
          invoiceDetails.date.substring(13, 14) +
          ' ' +
          invoiceDetails.date.substring(14, 16);
    }
    int tableId = invoiceDetails.table;
    return GridTile(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            InvoiceView.routeName,
            arguments: [widget.id, widget.deleteInvoice],
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding:
              const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 0, left: 0),
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  Colors.transparent,
                  Colors.transparent,
                ])),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    height: 65,
                    padding: const EdgeInsets.only(left: 15,right: 20, top: 2),
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).cardColor,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50)),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Material(
                                type: MaterialType.transparency,
                                child: Text(
                                  'Tisch:',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF2C3333),
                                  ),
                                ),
                              ),
                              Material(
                                type: MaterialType.transparency,
                                child: tableId != 0
                                    ? TableNameComponent(id: tableId)
                                    : Container(),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Material(
                                type: MaterialType.transparency,
                                child: Text(
                                  ' bezahlt um',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF2C3333),
                                  ),
                                ),
                              ),
                              Material(
                                type: MaterialType.transparency,
                                child: Container(
                                  width: 100,
                                  height: 38,
                                  padding: const EdgeInsets.all(6),
                                  margin: const EdgeInsets.only(left: 6),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColorDark,
                                    borderRadius:
                                        BorderRadius.circular(16.0),
                                  ),
                                  child: Text(
                                    date,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).cardColor,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 65,
                    padding: const EdgeInsets.only(top: 20, right: 15),
                    // color: Color.fromARGB(255, 21, 82, 71),
                    // padding: const EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).cardColor,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50)),
                      color: Theme.of(context).cardColor,

                      // color: Colors.white,
                      // boxShadow: [
                      //   const BoxShadow(color: Colors.green, spreadRadius: 3),
                      // ],
                    ),
                    // padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Material(
                          type: MaterialType.transparency,
                          child: Text(
                            invoiceDetails.amount.toString() + ' €',
                            textAlign: TextAlign.center,
                            // textAlign: TextAlign.end,
                            style: const TextStyle(
                                color: Color(0xFF2C3333),
                                fontSize: 20,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
