
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Providers/Ingredients.dart';
import '../../../Providers/TableItemChangeProvidor.dart';
import '../../../Providers/TableItemProvidor.dart';
import '../../../Providers/TableItemsProvidor.dart';
import '../../../Providers/Tables.dart';
import '../../dartPackages/another_flushbar/flushbar.dart';


class ChooseAmountWidget extends StatefulWidget {
  ChooseAmountWidget({Key? key, required this.tableName, required this.productReadyToEnter}) : super(key: key);

  late final tableName;
  final Function productReadyToEnter;
  @override
  _ChooseAmountWidgetState createState() => _ChooseAmountWidgetState();
}

class _ChooseAmountWidgetState extends State<ChooseAmountWidget> {


  late TableItemProvidor tableItemProvidor;
  late TableItemsProvidor tIP;


  @override
  Widget build(BuildContext context) {
    var tableItemChangeProvidor = Provider.of<TableItemChangeProvidor>(context, listen: true);
    var ingedienceProv = Provider.of<Ingredients>(context, listen: true);
    try {
      tIP = Provider
          .of<Tables>(context, listen: true)
          .findById(widget.tableName)
          .tIP;
      final int x = tableItemChangeProvidor.getActProduct()!;
      tableItemProvidor = tIP.tableItems[x];
    }
    catch (e){
      print("Table ID: " + widget.tableName.toString());
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.only(right: 5, left: 5, top: 20, bottom: 5),
      child:
      Center(
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if(!(tableItemProvidor.getPaymode() || tableItemProvidor.isFromServer())) {
                        setState(() {
                          tableItemProvidor.addQuantity(amountToAdd: -1, context: context);
                        });
                      } else {
                        Flushbar(
                          message: "Produkt gesperrt",
                          icon: Icon(
                            Icons.lock,
                            size: 28.0,
                            color: Colors.blue[300],
                          ),
                          margin: const EdgeInsets.all(8),
                          borderRadius: BorderRadius.circular(8),
                          duration: const Duration(seconds: 2),
                        ).show(context);
                      }
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        border: Border.all(
                            color: Colors.grey, width: 1),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(5.0) //
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "-",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: Center(
                      child: Text(
                        tableItemProvidor.quantity
                            .toStringAsFixed(0),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if(!(tableItemProvidor.getPaymode() || tableItemProvidor.isFromServer())) {
                        setState(() {
                          tableItemProvidor.addQuantity(amountToAdd: 1, context: context);
                        });
                      } else {
                        Flushbar(
                          message: "Produkt gesperrt",
                          icon: Icon(
                            Icons.lock,
                            size: 28.0,
                            color: Colors.blue[300],
                          ),
                          margin: const EdgeInsets.all(8),
                          borderRadius: BorderRadius.circular(8),
                          duration: const Duration(seconds: 2),
                        ).show(context);
                      }
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        border: Border.all(
                            color: Colors.grey, width: 1),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(5.0) //
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "+",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                if(!(tableItemProvidor.getPaymode() || tableItemProvidor.isFromServer())) {
                  for (int x = 0; x < tIP.tableItems.length; x++) {
                    if (tIP.tableItems[x].id == tableItemProvidor.id) {
                      tIP.removeSingelProduct(pos: x, context: context);
                      widget.productReadyToEnter(skipAnimation: true);
                      return;
                    }
                  }
                } else {
                  Flushbar(
                    message: "Produkt gesperrt",
                    icon: Icon(
                      Icons.lock,
                      size: 28.0,
                      color: Colors.blue[300],
                    ),
                    margin: const EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(8),
                    duration: const Duration(seconds: 2),
                  ).show(context);
                }
              },
              child: Container(
                width: 150,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  border: Border.all(
                      color: Colors.red, width: 1),
                  borderRadius: const BorderRadius.all(
                      Radius.circular(5.0) //
                  ),
                ),
                child: const Center(
                  child: Text(
                    "delete",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}