import "package:flutter/material.dart";
import '../../Providers/Tables.dart';
import '../../screens/TableViewScreen.dart';
import 'package:provider/provider.dart';
import '../../Providers/Authy.dart';

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
    // final table = Provider.of<TableProvider>(context, listen: true);
    final token_provider = Provider.of<Authy>(context, listen: true);
    final token = token_provider.token;
    // setState(() {
    //   table_total_price = table.total_price;
    // });
    // final String id = ModalRoute.of(context)?.settings.arguments as String;
    final tablData = Provider.of<Tables>(context, listen: true);

    final tabl = tablData.findById(widget.id);
    if (_isInit == true) {
      // connect the socket if _isInit

      _isInit = false;
    }

    final t = tabl.total_price;

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
              const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 0, left: 0),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  Theme.of(context).cardColor,
                  Theme.of(context).cardColor,
                ])),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    height: 75,
                    padding: const EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .primaryColorDark
                              .withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50)),
                      color: Theme.of(context).primaryColorDark,
                    ),
                    child: Column(
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
                              color: Theme.of(context).cardColor,
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
                              color: Theme.of(context).cardColor,
                              fontSize: 25,
                            ),
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
                  flex: 4,
                  child: Container(
                    height: 75,
                    padding: const EdgeInsets.only(top: 20, right: 15),
                    // color: Color.fromARGB(255, 21, 82, 71),
                    // padding: const EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .primaryColorDark
                              .withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      border: Border.all(
                        color: Theme.of(context).primaryColorDark,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50)),
                      color: Theme.of(context).primaryColorDark,

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
                            t.toString(),
                            textAlign: TextAlign.center,
                            // textAlign: TextAlign.end,
                            style: TextStyle(
                                color: Theme.of(context).cardColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
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