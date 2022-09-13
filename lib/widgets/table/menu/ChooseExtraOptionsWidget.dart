
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Providers/Ingredients.dart';
import '../../../Providers/TableItemChangeProvidor.dart';
import '../../../Providers/TableItemProvidor.dart';
import '../../../Providers/TableItemsProvidor.dart';
import '../../../Providers/Tables.dart';
import '../../dartPackages/another_flushbar/flushbar.dart';
import '../HorizontalAlphabetGridviewControllerWidget.dart';
import '../IngredientsGridView.dart';


class ChooseExtraOptionWidget extends StatefulWidget {
  ChooseExtraOptionWidget({Key? key, required this.tableName}) : super(key: key);

  late final tableName;
  @override
  _ChooseExtraOptionWidgetState createState() => _ChooseExtraOptionWidgetState();
}

class _ChooseExtraOptionWidgetState extends State<ChooseExtraOptionWidget> {


  final _scrollController = ScrollController();

  final GlobalKey<IngredientsGridViewState> ingredientsGridViewKey = const GlobalObjectKey<IngredientsGridViewState>(1);

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
      print("CEOW coulden't get Ingredients: " + e.toString());
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.only(right: 5, left: 5, top: 20, bottom: 5),
      child: Column(
        children: [
          Expanded(
            child:
            Scrollbar(
              interactive: true,
              thickness: 5,
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: SingleChildScrollView(
                  //physics: const NeverScrollableScrollPhysics(),
                  controller: _scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children:  <Widget> [
                          SizedBox(
                            width: MediaQuery.of(context).size.width /3 - 30,
                            child:
                            const Divider(
                              height: 5,
                              thickness: 1.5,
                              color: Colors.grey,
                            ),
                          ),
                          const Spacer(),
                          const Text("Zuätze des Gerichtes", style: TextStyle(color: Colors.grey, fontSize: 11),),
                          const Spacer(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width /3 - 30,
                            child:
                            const Divider(
                              height: 5,
                              thickness: 1.5,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: (2 / 1),
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        children:
                        List.generate(tableItemProvidor.added_ingredients.length, (index) {
                          return GestureDetector(
                            onTap: (){
                              setState((){
                                if(!(tableItemProvidor.getPaymode() || tableItemProvidor.isFromServer())) {
                                  tableItemProvidor.added_ingredients.removeAt(
                                      index);
                                  tableItemProvidor.notify(context);
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
                                    duration: const Duration(seconds: 4),
                                  ).show(context);
                                }
                              });
                            },
                            child: Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD3E03A),
                                  border: Border.all(
                                      color: Colors.grey,
                                      width: 0.5),
                                  borderRadius:
                                  const BorderRadius.all(
                                      Radius.circular(
                                          5.0) //
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(ingedienceProv.findById(tableItemProvidor.added_ingredients[index]).name, overflow: TextOverflow.ellipsis, style: const
                                    TextStyle(color: Colors.black,fontSize: 13),),
                                    Text(ingedienceProv.findById(tableItemProvidor.added_ingredients[index]).price.toStringAsFixed(2) + " €", style: const
                                    TextStyle(color: Colors.black,fontSize: 13, fontWeight: FontWeight.bold),),
                                  ],
                                )
                            ),
                          );
                        }).toList(),
                      ),
                      // tableItemProvidor.getPaymode() || tableItemProvidor.isFromServer()
                      //     ? Container()
                      //     :
                      IngredientsGridView(key: ingredientsGridViewKey, tableID: widget.tableName, width: MediaQuery.of(context).size.width,),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: HorizontalAlphabetGridviewControllerWidget(gridViewKey: ingredientsGridViewKey),
          ),
        ],
      ),
    );
  }
}
