import 'dart:convert';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspery_pos/screens/SignInScreen.dart';
import 'package:provider/provider.dart';

import '../Providers/Authy.dart';
import '../printer/ConfigPrinter.dart';
import '../widgets/NavBar.dart';
import 'SplashScreen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
  static const routeName = '/profile';
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isLoading = true;
  bool _isInit = true;

  num gesammt = 0;
  double tip = 46.128;
  double bar = 302.45;
  double karte = 244.87;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    bool isLoading = true;
    Future<void> getDailyInvoice() async {
      String token = Provider.of<Authy>(context, listen: false).token;
      final url = Uri.parse(
        'https://www.inspery.com/invoice/daily_invoice/',
      );
      final headers = {
        "Content-type": "application/json",
        "Authorization": "Token ${token}"
      };
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 201) {
        setState(() {
          gesammt = jsonDecode(response.body)['sum'];
        });
        setState(() {
          _isLoading = false;
        });
      } else {
        print(
            'Request failed with status: ${response.statusCode}. invoice/daily_invoice/');
        print(
            'Request failed with status: ${response.body}. invoice/daily_invoice/');
      }
    }

    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      getDailyInvoice();
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final authy = Provider.of<Authy>(context);
    final img = authy.photoLink;
    final String userName = authy.userName;
    logout() {
      authy.logout();
      Navigator.of(context).pushNamed(
        SignIn.routeName,
        // arguments: widget.id.toString()
        // // , "table": table
        // // },
      );
    }

    return _isLoading == true
        ? SplashScreen()
        : Scaffold(
            bottomNavigationBar: const NavBar(selectedIcon: 4),
            body: Container(
              child: ListView(
                children: [
                  Row(
                    children: [
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: img != ''
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(75.0),
                                      child: Image.network(
                                        img,
                                        height: 150,
                                        width: 150,
                                      ),
                                    )
                                  : const Text(''),
                            ),
                            Text(
                              '@' + authy.userName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2C3333),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          child: const Icon(Icons.logout),
                          onTap: () {
                            logout();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                      child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).primaryColorDark,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10, left: 15),
                          child: Row(children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Umstaz',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).cardColor,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                margin: const EdgeInsets.only(
                                  right: 15,
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    final ConfigPrinter _configPrinter = ConfigPrinter();
                                    print("connection " +
                                        (await _configPrinter.checkState(context: context).toString()));
                                    BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
                                    var now = DateTime.now();
                                    var formatter = DateFormat('HH:mm dd-MM-yyyy');
                                    String formattedDate = formatter.format(now);
                                    bluetooth.isConnected.then((isConnected) {
                                      if (isConnected ?? false) {
                                        bluetooth.printNewLine();
                                        bluetooth.printCustom("Tagesabrechnung", 2, 1);
                                        bluetooth.printNewLine();
                                        bluetooth.printCustom(formattedDate, 1, 0);
                                        bluetooth.printCustom(authy.userName, 1, 0);
                                        bluetooth.printNewLine();
                                        bluetooth.printLeftRight("Gesammt", gesammt.toString(), 1);
                                        bluetooth.printLeftRight("Karte", karte.toStringAsFixed(2), 1);
                                        bluetooth.printLeftRight("Bar", bar.toStringAsFixed(2), 1);
                                        bluetooth.printLeftRight("Tip", tip.toStringAsFixed(2), 1);
                                        bluetooth.printNewLine();
                                        bluetooth.printQRcode("https://www.inspery.com/", 150, 150, 1);
                                        bluetooth.printNewLine();
                                        bluetooth.printNewLine();
                                        bluetooth.printNewLine();
                                      }
                                    });


                                  },
                                  child: Icon(
                                    Icons.print,
                                    color: Theme.of(context).cardColor,
                                    size: 24.0,
                                    semanticLabel:
                                        'Text to announce in accessibility modes',
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 15, top: 5, right: 7.5, bottom: 5),
                                child: Column(children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      'gesammt',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 7, bottom: 7),
                                    child: Text(
                                      gesammt.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                    ),
                                  ),
                                ]),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context).cardColor,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 7.5, right: 15, top: 5, bottom: 5),
                                child: Column(children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      'Tip',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 7, bottom: 7),
                                    child: Text(
                                      tip.toStringAsFixed(2),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                    ),
                                  ),
                                ]),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context).cardColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 15, right: 7.5, top: 5, bottom: 15),
                                child: Column(children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      'EC',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 7, bottom: 7),
                                    child: Text(
                                      karte.toStringAsFixed(2),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                    ),
                                  ),
                                ]),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context).cardColor,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 7.5, right: 15, top: 5, bottom: 15),
                                child: Column(children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      'Bar',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 7, bottom: 7),
                                    child: Text(
                                      bar.toStringAsFixed(2),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                    ),
                                  ),
                                ]),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context).cardColor,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
                  SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                        ),
                      )),
                ],
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
            ),
          );
  }
}

