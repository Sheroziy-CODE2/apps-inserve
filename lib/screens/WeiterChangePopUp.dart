
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/TableModel.dart';
import '../Providers/Authy.dart';
import '../Providers/Tables.dart';
import '../Providers/WorkersProvider.dart';
import '../widgets/ImageButtons.dart';
import '../widgets/SelectButtons.dart';
import '../widgets/dartPackages/another_flushbar/flushbar.dart';
import 'TablesViewScreen.dart';


//ShowDialog to change the tables owner.
class WeiterChange {

  static WeiterChange ? utility;

  static WeiterChange? getInstance() {
    utility ??= WeiterChange();
    return utility;
  }

  final List <String> _chosenTable = [];

  final List <String> _chosenWorker= [""];

  late Tables tablesprov;

  showWeiterChangeDialog(BuildContext context) {

    final authy = Provider.of<Authy>(context, listen: false);

    final tablesData = Provider.of<Tables>(context, listen: false);
    final tables = tablesData.items;
    List<TableModel> ownedTables = [];

    final workersData = Provider.of<WorkersProvider>(context, listen: false);
    final worker = workersData.items;


    var loggedInUser = workersData.findByName(authy.userName).id;

    ownedTables = tables.where((i) => i.owner == loggedInUser).toList();

    List workers = [];

    for (int i = 0; i < worker.length; i++) {
      if (worker[i].id != loggedInUser){
        workers.add(worker[i].username);
      }
    }

    List workersImage = [];

    for (int i = 0; i < worker.length; i++) {
      if (worker[i].id != loggedInUser){
        workersImage.add(worker[i].profile);
      }
    }


    List _buttonText = [];

    for (int i = 0; i < ownedTables.length; i++) {
      _buttonText.add(ownedTables[i].name.replaceAll(RegExp(r'[^0-9]'), ''));
    }
    _buttonText.sort();

    tablesprov = Provider.of<Tables>(context, listen: false);


    Widget transfer = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          child: const Text("                  ÜBERGEBEN                  "),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Theme
                  .of(context)
                  .primaryColorDark),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              alignment: Alignment.center
          ),
          onPressed: () {
            List tableToTransfer = [];
            if (_chosenWorker[0] != "" && _chosenTable.isNotEmpty){
              for (int i = 0; i < _chosenTable.length; i++){
                tableToTransfer.add(tablesData.findByName(_chosenTable[i]).id);
              }
              //var tableToTransfer = tablesData.findByName(_chosenTable[0]).id;
              tablesprov.transferTableToAnotherUserSocket(newUserID: _chosenWorker[0], tableIDs: tableToTransfer);
              Navigator.of(context).pushReplacementNamed(TablesView.routeName);
              Flushbar(
                message: "Die Tabelle: "+_chosenTable.join(", ").toString()+" wurde an den Benutzer übertragen: "+ _chosenWorker[0],
                icon: Icon(Icons.info_outline, size: 28.0, color: Colors.blue[300],),
                margin: const EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(8),
                duration:  const Duration(seconds: 2),
              ).show(context);
              _chosenWorker[0] = "";
              _chosenTable.clear( );
            }
            else {
              Flushbar(
                message: "Sie müssen sowohl die übertragende Tabelle als auch den Arbeiter, der sie erhält, auswählen.",
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
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child : ListBody(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: const Text('Tische zum weitergeben',
                        maxLines: 1, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 10),
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
                                      _chosenTable.add(_buttonText[index]);
                                    }
                                    else {
                                      _chosenTable.remove(_buttonText[index]);
                                    }
                                  });
                                },
                                buttonText: _buttonText[index],
                                selectedColor: Theme.of(context).primaryColorDark,
                                unselectedColor: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(30),
                                chosenButton: _chosenTable);
                          })

                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    color: Colors.black,
                    height: 5,
                    indent: 0,
                    endIndent: 0,
                    thickness: 2,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.center,
                    child: const Text('Kollegen wählen',
                        maxLines: 1, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight:  MediaQuery.of(context).size.height / 3),
                      child: GridView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: workers.length,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.95,
                          ),

                          itemBuilder: (BuildContext context, int index) {
                            return MyImageButton(
                              buttonTapped: () {
                                setState(() {
                                  _chosenWorker[0] = workers[index];
                                  debugPrint("YOU CHOSE "+ _chosenWorker[0]);
                                });
                              },
                              unselectedIconColor: Colors.transparent,
                              selectedIconColor: Theme.of(context).primaryColorDark,
                              image: workersImage[index],
                              borderRadius: BorderRadius.circular(30),
                              username: workers[index],
                              chosenButton: _chosenWorker[0],
                            );
                          })
                  ),
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
        }
    );
  }

}