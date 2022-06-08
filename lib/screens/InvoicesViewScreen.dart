import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:inspery_pos/Providers/categoryss.dart';
import '../widgets/table/TableItemWidget.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
import '../Providers/Tables.dart';
import '../Providers/Authy.dart';
import '../Models/Invoice.dart';

import '../widgets/NavBar.dart';
import '../widgets/invoice/InvoiceItemWidget.dart';

class InvoicesView extends StatefulWidget {
  // const TablesView({Key? key}) : super(key: key);
  static const routeName = '/invoces_screen';

  @override
  State<InvoicesView> createState() => _InvoicesScreen();
}

class _InvoicesScreen extends State<InvoicesView> {
  var _isInit = true;
  var _isLoading = true;
  List<Invoice> invoices = [];
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
    final tokenData = Provider.of<Authy>(context);
    String token = tokenData.token;
    addInvoices(token);
    super.didChangeDependencies();
  }

  void setItems(items) {
    setState(() {
      invoices = items;
    });
  }

  // const  ({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    setState(() {
      _isLoading = false;
    });
    final invoicesList = invoices;

    return Scaffold(
      bottomNavigationBar: const NavBar(selectedIcon: 3),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.bottomRight,
                      //stops: const [0, 1],
                      colors: [
                    const Color(0x00535353).withOpacity(.8),
                    const Color(0xFF535353).withOpacity(.1)
                  ])),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: const Text(
                        'Rechnungen',
                        textAlign: TextAlign.center,
                        // textAlign: TextAlign.end,
                        style: TextStyle(
                            color: Color(0xFF2C3333),
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            fontStyle: FontStyle.normal),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: ListView.builder(
                      itemCount: invoicesList.length,
                      itemBuilder: (context, index) =>
                          InvoiceItemWidget(id: invoicesList[index].id),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Future<void> addInvoices(token) async {
    final url = Uri.parse(
      'https://www.inspery.com/invoice/',
    );
    final headers = {
      "Content-type": "application/json",
      'Authorization': 'Token $token',
    };
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      final List<Invoice> loededTables = [];
      List<Invoice> items = [];
      for (int i = 0; i < data.length; i++) {
        var o = Invoice.fromJson(data[i]);
        items.add(o);
      }
      setItems(items);
      print(invoices);
      print(invoices);
    } else {
      print('Request failed with status: ${response.statusCode}. invoice/');
      print(response.reasonPhrase);
    }
  }
}
