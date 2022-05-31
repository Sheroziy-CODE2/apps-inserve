import "package:flutter/material.dart";
import '../../Models/TableModel.dart';
import '../../Providers/Tables.dart';
import '../../screens/TableViewScreen.dart';
import 'package:provider/provider.dart';
import '../../Providers/Authy.dart';
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
  bool dropDownHistoryTime = false;

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

    const double dropdownHight = 47;

    return GridTile(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(TableView.routeName, arguments: widget.id.toString()
            // , "table": table
            // },
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding:
          const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  //height: 75,
                  padding: const EdgeInsets.only(top: 5,left: 5, bottom: 15, right: 5),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                                fontWeight: FontWeight.bold,
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
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10, top: dropDownHistoryTime ? 10 : 0),
                        child: Column(
                          children: [
                            dropDownHistoryTime ? Container() : Text(
                              "letzte Buchung",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 11,
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  dropDownHistoryTime = !dropDownHistoryTime;
                                  print("Length of hist: " + tabl.timeHistory.length.toString());
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 100),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10)),
                                  color: Color(0xFF25363E),
                                ),
                                width: 114,
                                height: dropDownHistoryTime ? dropdownHight * tabl.timeHistory.length : dropdownHight,
                                child: dropDownHistoryTime ?
                                ListView.builder(
                                  itemCount: tabl.timeHistory.length,
                                  itemBuilder: (context, i) {
                                    return Column(
                                      children: [
                                        Text(
                                          tabl.timeHistory.keys.toList()[i],
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).cardColor,
                                            fontSize: 11,
                                          ),
                                        ),
                                        Center(
                                          child: Text( tabl.timeHistory.values.toList()[i] == 0 ? "- : -" :
                                            formatter.format(DateTime.fromMillisecondsSinceEpoch((tabl.timeHistory.values.toList()[i]*1000).round())),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).cardColor,
                                              fontSize: 25,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                )
                                :Center(
                                  child: Text(
                                    updateTime,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).cardColor,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  height: 75,
                  padding: const EdgeInsets.only(top: 5, right: 15),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Material(
                        type: MaterialType.transparency,
                        child: Column(
                          children: [
                            Text(
                              "Die Rechnung",
                              textAlign: TextAlign.center,
                              // textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  fontStyle: FontStyle.normal),
                            ),
                            Text(
                              t.toStringAsFixed(2).replaceFirst(".", ","),
                              textAlign: TextAlign.center,
                              // textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  fontStyle: FontStyle.normal),
                            ),
                          ],
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
    );
  }
}
