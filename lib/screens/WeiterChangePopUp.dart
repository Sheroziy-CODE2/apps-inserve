
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/TableModel.dart';
import '../Providers/Authy.dart';
import '../Providers/Tables.dart';
import '../Providers/WorkersProvider.dart';
import '../widgets/ImageButtons.dart';
import '../widgets/SelectButtons.dart';
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

  void snackBar({required String msg, required context}){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.transparent,
              duration: const Duration(seconds: 4),
              content:
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                      Radius.circular(5)),
                  color: Theme.of(context).primaryColorDark,
                ),
                height: 60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline, size: 28.0, color: Colors.blue[300],),
                    const SizedBox(width: 6,),
                    SizedBox(
                        height: 120,
                        width: MediaQuery.of(context).size.width-220,
                        child: Text(msg,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 6,)
                    ),
                  ],
                ),
              ),

            )
        );
  }

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


    ScrollController scrollController = ScrollController();

    StatefulBuilder builder = StatefulBuilder(
      builder: (BuildContext contextXX, setState) {
        return AlertDialog(
          content: SizedBox(
            width: MediaQuery.of(context).size.width-20,
            height: MediaQuery.of(context).size.height-200,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child : Column(
                  mainAxisSize: MainAxisSize.min,
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
                    Scrollbar(
                      interactive: true,
                      thumbVisibility: true,
                      trackVisibility: true,
                      thickness: 5,
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight:  MediaQuery.of(context).size.height / 3),
                            child: GridView.builder(
                                controller: scrollController,
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
                      ),
                    ),
                    const SizedBox(height: 10,),
                    ElevatedButton(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width -50,
                          child: const Center(child: Text("ÜBERGEBEN"))
                      ),
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
                          snackBar(msg: "Die Tabelle: "+_chosenTable.join(", ").toString()+" wurde an den Benutzer übertragen: "+ _chosenWorker[0], context: contextXX);
                          _chosenWorker[0] = "";
                          _chosenTable.clear( );
                        }
                        else {
                          snackBar(msg: "Sie müssen sowohl die übertragende Tabelle als auch den Arbeiter, der sie erhält, auswählen.", context: contextXX);
                        }

                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    // show the dialog
    showDialog(
        useRootNavigator: false,
        context: context,
        builder: (BuildContext contextY) {
          return builder;
        }
    );
  }
}

