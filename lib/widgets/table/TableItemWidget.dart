import "package:flutter/material.dart";
import 'package:inspery_waiter/Providers/WorkersProvider.dart';
import 'package:inspery_waiter/widgets/table/tables/TablesNotificationWidget.dart';
import '../../Models/TableModel.dart';
import '../../Providers/Tables.dart';
import '../../screens/TableViewScreen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TableItem extends StatefulWidget {
  late final int id;

  TableItem({
    required this.id,
  });

  @override
  State<TableItem> createState() => _TableItemState();
}

class _TableItemState extends State<TableItem> {
  double table_total_price = 0;
  var _isInit = true;

  /// Listen for all incoming data
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tablData = Provider.of<Tables>(context, listen: true);

    final TableModel tabl = tablData.findById(widget.id);
    if (_isInit == true) {
      // connect the socket if _isInit

      _isInit = false;
    }

    final t = tabl.total_price;
    String updateTime = "- : -";
    final DateFormat formatter = DateFormat('hh : mm');
    if(tabl.timeHistory.keys.contains("Buchung")){
      if(tabl.timeHistory["Buchung"]! != 0) {
        updateTime = formatter.format(DateTime.fromMillisecondsSinceEpoch((tabl.timeHistory["Buchung"]!*1000.0).round()));
      }
    }

    Widget getWorkerImage(){
      try{
        return Image.network(
          "https://www.inspery.com/"+
          Provider.of<WorkersProvider>(context, listen: false).findById(tabl.owner!).profile!,
          fit: BoxFit.fill,
          width: 40,
          height: 40,
        );
      }
      catch (e){};
      return Image.asset("assets/images/logo_icon.png", fit: BoxFit.fill);
    }

    return GridTile(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(TableView.routeName, arguments: widget.id.toString()
            // , "table": table
            // },
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 7, bottom: 7),
          child: SizedBox(
            height: 63,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    //height: 75,
                    padding: const EdgeInsets.only(top: 5,left: 5, bottom: 5, right: 15),
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .primaryColorDark
                              .withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset:
                          const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50)),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 5,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Material(
                              type: MaterialType.transparency,
                              child: Text(
                                tabl.type,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                            ),
                            Material(
                              type: MaterialType.transparency,
                              child: Text(
                                tabl.name,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Theme.of(context).primaryColorDark,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              tabl.timeHistory["Buchung"] == 0 ? "- : -" : formatter.format(DateTime.fromMillisecondsSinceEpoch((tabl.timeHistory["Buchung"]!*1000).round())),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 13,
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                //setState(() {
                                  var alert = AlertDialog(
                                    actions: <Widget>[
                                      ElevatedButton(
                                          child: const Text('Okay'), onPressed: () => {Navigator.of(context).pop()})
                                    ],
                                    title: const Text("Historie"),
                                    content: SizedBox(
                                      height: 200,
                                      width: 100,
                                      child: ListView.builder(
                                        itemCount: tabl.timeHistory.length,
                                        itemBuilder: (context, i) {
                                          return Column(
                                            children: [
                                              Text(
                                                tabl.timeHistory.keys.toList()[i],
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              Center(
                                                child: Text( tabl.timeHistory.values.toList()[i] == 0 ? "- : -" :
                                                formatter.format(DateTime.fromMillisecondsSinceEpoch((tabl.timeHistory.values.toList()[i]*1000).round())),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 26,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                  // show the dialog
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return alert;
                                    },
                                  );
                                //});
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: getWorkerImage(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 50,
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            height: 5,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .primaryColorDark
                                      .withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset:
                                  const Offset(0, 3), // changes position of shadow
                                ),
                              ],
                              color: Theme.of(context).cardColor,//Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                        Positioned(
                            child: Center(child: TablesNotificationWidget(tableID: widget.id,))
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 65,
                    padding: const EdgeInsets.only(top: 5, right: 10),
                    // color: Color.fromARGB(255, 21, 82, 71),
                    // padding: const EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .primaryColorDark
                              .withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset:
                          const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50)),
                      color: Theme.of(context).cardColor,//Theme.of(context).primaryColorDark,

                      // color: Colors.white,
                      // boxShadow: [
                      //   const BoxShadow(color: Colors.green, spreadRadius: 3),
                      // ],
                    ),
                    // padding: const EdgeInsets.all(10),
                    child:
                    Material(
                      type: MaterialType.transparency,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "Die Rechnung",
                            textAlign: TextAlign.center,
                            // textAlign: TextAlign.end,
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 9,
                                fontStyle: FontStyle.normal),
                          ),
                          Text(
                            t.toStringAsFixed(2).replaceFirst(".", ","),
                            textAlign: TextAlign.center,
                            // textAlign: TextAlign.end,
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontWeight: FontWeight.normal,
                                fontSize: 19,
                                fontStyle: FontStyle.normal),
                          ),
                        ],
                      ),
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
