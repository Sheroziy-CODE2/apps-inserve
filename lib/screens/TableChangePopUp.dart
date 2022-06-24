import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/TableModel.dart';
import '../Providers/Authy.dart';
import '../Providers/Tables.dart';
import '../Providers/WorkersProvider.dart';
import '../widgets/Buttons.dart';
import '../widgets/SelectButtons.dart';
import '../widgets/dartPackages/another_flushbar/flushbar.dart';
import 'TablesViewScreen.dart';

//The ShowDialog about changing all items from one table to another.

class TableChange {
  static TableChange? utility = null;

  static TableChange? getInstance() {
    utility ??= TableChange();
    return utility;
  }

  static const snackBarTable = SnackBar(
    content: Text('Such Table doesnt exist'),
  );

  var userText = "";


  final List<String> _chosenTable = [""];

  late Tables tablesprov;

  //ShowDialog to choose the table
  showTableChangeDialog(BuildContext context) {
    final authy = Provider.of<Authy>(context, listen: false);

    final tablesData = Provider.of<Tables>(context, listen: false);
    final tables = tablesData.items;
    List<TableModel> ownedTables = [];

    final workersData = Provider.of<WorkersProvider>(context, listen: false);

    var id = workersData.findByName(authy.userName).id;
    ownedTables = tables.where((i) => i.owner == id).toList();

    List _buttonText = [];

    for (int i = 0; i < ownedTables.length; i++) {
      _buttonText.add(ownedTables[i].name.replaceAll(RegExp(r'[^0-9]'), ''));
    }

    _buttonText.sort();

    Widget transfer = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          child: Text("                  ÜBERGEBEN                  "),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColorDark),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              alignment: Alignment.center),
          onPressed: () {
            if (_chosenTable[0] != "") {
              TableChange.getInstance()?.showTableSearchDialog(context);
            } else {
              Flushbar(
                message: "Sie müssen die Tabelle auswählen.",
                icon: Icon(Icons.info_outline, size: 28.0, color: Colors.blue[300],),
                margin: const EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(8),
                duration:  const Duration(seconds: 2),
              ).show(context);
              //debugPrint("CHOOSE THE TABLE");
            }
          },
        )
      ],
    );

    StatefulBuilder builder = StatefulBuilder(
      builder: (BuildContext context, setState) {
        return AlertDialog(
          title: const Text("Tische zum weitergeben",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          content: Container
            (
            width: MediaQuery.of(context).size.width,
            height: (_buttonText.length <= 8) ? MediaQuery.of(context).size.height / 5 : MediaQuery.of(context).size.height / 4,
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: (_buttonText.length <= 8) ? MediaQuery.of(context).size.height / 5 : MediaQuery.of(context).size.height / 4),
                      child: GridView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: _buttonText.length,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return MySelectedButton(
                                buttonTapped: () {
                                  setState(() {
                                    if (!_chosenTable.contains(_buttonText[index])){
                                      _chosenTable[0] = _buttonText[index];
                                    }
                                    else {
                                      _chosenTable[0] = "";
                                    }
                                  });
                                },
                                buttonText: _buttonText[index],
                                selectedColor: Theme.of(context).primaryColorDark,
                                unselectedColor: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(30),
                                chosenButton: _chosenTable);
                          })),
                ],
              ),
            ),
          ),
          actions: [transfer],
        );
      },
    );
    // show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return builder;
        });
  }

  //ShowDialog to find the table by putting the table number
  showTableSearchDialog(BuildContext context) {


    final tablesData = Provider.of<Tables>(context, listen: false);


    tablesprov = Provider.of<Tables>(context, listen: false);

    final List<String> buttons = [
      "7", "8", "9",
      "4", "5", "6",
      "1", "2", "3",
      "0", ".", "DEL",
    ];

    Widget transfer = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          child: Text("                  UMBUCHEN                  "),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColorDark),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              alignment: Alignment.center),
          onPressed: () {
            var id = tablesData.findByName(userText).id;
            if (id != 0) {
              var newTableId = tablesData.findByName(userText).id;
              var oldTableId = tablesData.findByName(_chosenTable[0]).id;
              tablesprov.transferAllItemsToSocket(context: context, tableID: oldTableId, newTableID: newTableId);
              Navigator.of(context).pushReplacementNamed(TablesView.routeName);
              Flushbar(
                message: "Alle Tabellenbestellungen aus " +_chosenTable[0]+" wurden in den "+userText+" übertragen",
                icon: Icon(Icons.info_outline, size: 28.0, color: Colors.blue[300],),
                margin: const EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(8),
                duration:  const Duration(seconds: 2),
              ).show(context);
              userText = _chosenTable[0] = "";
            }
            else {
              Flushbar(
                message: "Die Tabelle, die Sie hinzugefügt haben, existiert nicht, bitte versuchen Sie eine andere Tabelle",
                icon: Icon(Icons.info_outline, size: 28.0, color: Colors.blue[300],),
                margin: const EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(8),
                duration:  const Duration(seconds: 2),
              ).show(context);
            }


          },
        )
      ],
    );

    StatefulBuilder builder = StatefulBuilder(
      builder: (BuildContext context, setState) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: 500,
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 120),
                    child: Container(
                      child: Column(children: <Widget>[
                        const SizedBox(height: 5),
                        Container(
                          alignment: Alignment.topRight,
                          child: const Text('Tisch existiert: ',
                              maxLines: 1, style: TextStyle(fontSize: 20)),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Text(userText,
                              maxLines: 1, style: const TextStyle(fontSize: 50)),
                        ),
                      ]),
                    ),
                  ),
                  ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 400),
                      child: GridView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: buttons.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 11) {
                              return MyButton(
                                  buttonTapped: () {
                                    setState(() {
                                      userText = "";
                                    });
                                  },
                                  buttonText: buttons[index],
                                  color: Theme.of(context).primaryColorDark,
                                  textColor: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10));
                            } else {
                              return MyButton(
                                  buttonTapped: () {
                                    setState(() {
                                      userText += buttons[index];
                                    });
                                  },
                                  buttonText: buttons[index],
                                  color: Theme.of(context).primaryColorDark,
                                  textColor: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10));
                            }
                          })),
                ],
              ),
            ),
          ),
          actions: [transfer],
        );
      },
    );
    // show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return builder;
        });
  }
}
