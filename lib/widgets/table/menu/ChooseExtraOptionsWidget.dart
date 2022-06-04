
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Providers/Ingredients.dart';
import '../../../Providers/TableItemChangeProvidor.dart';
import '../../../Providers/TableItemProvidor.dart';
import '../../../Providers/TableItemsProvidor.dart';
import '../../../Providers/Tables.dart';
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
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: Row(
              children: [
                const Text(
                  "Extras",
                    //productProvidor.findById(tableItemProvidor.product).name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )),
                const Spacer(),
                // Text(
                //     tableItemProvidor.getTotalPrice(context: context).toStringAsFixed(2) + "€",
                //     style: const TextStyle(
                //       fontSize: 18,
                //       color: Colors.black,
                //     )),
                tableItemProvidor.getPaymode() || tableItemProvidor.isFromServer()
                    ? Container()
                    : Row(children: [
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState((){
                        tableItemProvidor.addQuantity(amountToAdd: -1, context: context);
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
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
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(
                      child: Text(
                        tableItemProvidor.quantity
                            .toStringAsFixed(0),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState((){
                        tableItemProvidor.addQuantity(amountToAdd: 1, context: context);
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
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
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
          Expanded(
            // SizedBox( //ok
            //   height: ((tIP.hight_mode_extendet
            //       ? widget.height_expended
            //       : widget.height) * 0.6 )- 95,
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
                              thickness: 1,
                              color: Colors.grey,
                            ),
                          ),
                          const Spacer(),
                          const Text("Beilagen des Gerichtes", style: TextStyle(color: Colors.grey, fontSize: 11),),
                          const Spacer(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width /3 - 30,
                            child:
                            const Divider(
                              height: 5,
                              thickness: 1,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: (1 / .6),
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        shrinkWrap: true,
                        crossAxisCount: 5,
                        children:
                        List.generate(tableItemProvidor.added_ingredients.length, (index) {
                          return GestureDetector(
                            onTap: (){
                              setState((){
                                if(!(tableItemProvidor.getPaymode() || tableItemProvidor.isFromServer())) {
                                  tableItemProvidor.added_ingredients.removeAt(
                                      index);
                                  tableItemProvidor.notify(context);
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
                                  children: [
                                    Text(ingedienceProv.findById(tableItemProvidor.added_ingredients[index]).name, overflow: TextOverflow.ellipsis, style: const
                                    TextStyle(color: Colors.black,fontSize: 10),),
                                    Text(ingedienceProv.findById(tableItemProvidor.added_ingredients[index]).price.toStringAsFixed(2) + "€", style: const
                                    TextStyle(color: Colors.black,fontSize: 12, fontWeight: FontWeight.bold),),
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
          HorizontalAlphabetGridviewControllerWidget(gridViewKey: ingredientsGridViewKey),
        ],
      ),
    );
  }
}
