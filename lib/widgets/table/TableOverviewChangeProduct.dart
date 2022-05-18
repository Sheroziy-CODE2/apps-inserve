
import 'package:flutter/material.dart';
import 'package:inspery_pos/Providers/Ingredients.dart';
import 'package:inspery_pos/Providers/TableItemsProvidor.dart';
import 'package:inspery_pos/widgets/table/HorizontalAlphabetGridviewControllerWidget.dart';
import 'package:provider/provider.dart';

import '../../Providers/Products.dart';
import '../../Providers/TableItemChangeProvidor.dart';
import '../../Providers/TableItemProvidor.dart';
import '../../Providers/Tables.dart';
import 'IngredientsGridView.dart';

class TableOverviewChangeProduct extends StatefulWidget {
  const TableOverviewChangeProduct({
    required this.height,
    required this.width,
    required this.height_expended,
    required this.tableID,
    Key? key,
  }) : super(key: key);

  final double height_expended;
  final height;
  final width;
  final tableID;



  @override
  _TableOverviewChangeProductState createState() =>
      _TableOverviewChangeProductState();
}

class _TableOverviewChangeProductState
    extends State<TableOverviewChangeProduct> {

  final _scrollController = ScrollController();
  GlobalKey<IngredientsGridViewState> ingredientsGridViewKey = const GlobalObjectKey<IngredientsGridViewState>(1);

  late TableItemProvidor tableItemProvidor;
  late TableItemsProvidor tIP;
  @override
  Widget build(BuildContext context) {
    var tableItemChangeProvidor = Provider.of<TableItemChangeProvidor>(context, listen: true);
    var productProvidor = Provider.of<Products>(context, listen: true);
    var ingedienceProv = Provider.of<Ingredients>(context, listen: true);
    try {
      tIP = Provider
          .of<Tables>(context, listen: true)
          .findById(widget.tableID)
          .tIP;
      tableItemProvidor = tIP.tableItems[tableItemChangeProvidor.getActProduct()!];
    }
    catch (e){
      print("Table ID: " + widget.tableID.toString());
      print("TOCP coulden't get Ingredients: " + e.toString());
      return Container();
    }
    return Container(
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.only(top: 2, right: 5, left: 15),
        //duration: const Duration(milliseconds: 200),
        //curve: Curves.fastOutSlowIn,
        height: (tIP.hight_mode_extendet
            ? widget.height_expended
            : widget.height) * 0.6 - 50,
        //width: selectedItem != -1 ? width : 300,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(15.0) //
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                    productProvidor.findById(tableItemProvidor.product).name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )),
                const Spacer(),
                Text(
                    tableItemProvidor.getTotalPrice(context: context).toStringAsFixed(2) + "€",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    )),
                tableItemProvidor.getPaymode() || tableItemProvidor.isFromServer()
                    ? Container()
                    : Row(children: [
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      tableItemProvidor.addQuantity(amountToAdd: -1, context: context);
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
                      tableItemProvidor.addQuantity(amountToAdd: 1, context: context);
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
                const SizedBox(width: 10,),
                GestureDetector(
                  onTap: () {
                    tableItemChangeProvidor.showProduct(index: null, context: context);
                  },
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(
                      child: Icon(
                          Icons.cancel,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              // SizedBox( //ok
              //   height: ((tIP.hight_mode_extendet
              //       ? widget.height_expended
              //       : widget.height) * 0.6 )- 95,
              child:
              Scrollbar(
                isAlwaysShown: true,
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
                              width: widget.width /3 - 30,
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
                              width: widget.width /3 - 30,
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
                                if(!(tableItemProvidor.getPaymode() || tableItemProvidor.isFromServer())) {
                                  tableItemProvidor.added_ingredients.removeAt(
                                      index);
                                  tableItemProvidor.notify(context);
                                }
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
                                      Text(ingedienceProv.findById(tableItemProvidor.added_ingredients[index]).name, style: const
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
                        IngredientsGridView(key: ingredientsGridViewKey, tableID: widget.tableID, width: widget.width,),
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
        )
    );
  }

}
