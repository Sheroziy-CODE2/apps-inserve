import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../Providers/Authy.dart';
import '../Models/Invoice.dart';
import '../widgets/NavBar.dart';
import '../widgets/invoice/InvoiceItemWidget.dart';

class InvoicesView extends StatefulWidget {

  InvoicesView({Key? key}) : super(key: key);
  static const routeName = '/invoces_screen';

  @override
  State<InvoicesView> createState() => InvoicesScreenState();
}

class InvoicesScreenState extends State<InvoicesView> {
  var _isLoading = false;
  List<Invoice> invoices = [];
  bool refresh = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // get all the invoices
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

  void deleteInvoiceItem({required int id}){
    for(int x = 0; x < invoices.length; x ++){
      if(invoices[x].id == id){
          invoices.removeAt(x);
          setState(() {
            refresh = true;
          });
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if(refresh) {
      refresh = false;
      setState(() {
      _isLoading = false;
    });
    }
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
                colors: [
                  const Color(0x00535353).withOpacity(.8),
                  const Color(0xFF535353).withOpacity(.1)
                ])),
        child: SafeArea(
          child: Column(
            children: [
              /*const Text(
                'Heutige Rechnungen',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF2C3333),
                    fontSize: 16,
                    fontStyle: FontStyle.normal),
              ),*/
              const SizedBox(
                height: 20,
              ),
              invoicesList.isEmpty ?
                  Expanded(
                        child:
                        Center(
                          child: SizedBox(
                            height: 150,
                              child: Lottie.asset("assets/lottie/empty-box.json", repeat: false)),
                        ),
                  )
              : Expanded(
                child: ListView.builder(
                  itemCount: invoicesList.length,
                  itemBuilder: (context, index) =>
                      InvoiceItemWidget(id: invoicesList[index].id, deleteInvoice: deleteInvoiceItem),
                ),
              ),
            ],
          ),
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
      final data = List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(response.bodyBytes)));
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
