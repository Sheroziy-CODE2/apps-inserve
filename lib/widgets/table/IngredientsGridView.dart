import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/Ingredients.dart';
import '../../Providers/TableItemChangeProvidor.dart';
import '../../Providers/TableItemProvidor.dart';
import '../../Providers/TableItemsProvidor.dart';
import '../../Providers/Tables.dart';

class IngredientsGridView extends StatefulWidget {
  const IngredientsGridView({Key? key, required this.tableID, required this.width}) : super(key: key);

  final tableID;
  final width;

  @override
  IngredientsGridViewState createState() => IngredientsGridViewState();
}

class IngredientsGridViewState extends State<IngredientsGridView> {

  String _filterLetter = "#";

  void setFilterLetter({required filterLetter}){
    print("Set new letter: " + filterLetter);
    setState(() {
      _filterLetter = filterLetter;
    });
  }

  @override
  Widget build(BuildContext context) {
    var ingedienceProv = Provider.of<Ingredients>(context, listen: true);
    var tableItemChangeProvidor = Provider.of<TableItemChangeProvidor>(context, listen: true);
    late TableItemsProvidor tIP;
    late TableItemProvidor tableItemProvidor;
    try {
      tIP = Provider
          .of<Tables>(context, listen: true)
          .findById(widget.tableID)
          .tIP;
      tableItemProvidor = tIP.tableItems[tableItemChangeProvidor.getActProduct()!];
    }catch (e){
      print("IGV coulden't get Ingredients: " + e.toString());
      return Container(color: Colors.red);
    }

    var ingedienceProv_items = [];
    if (_filterLetter != "#") {
      for (var e in ingedienceProv.items) {
        if (e.name.toUpperCase().startsWith(_filterLetter)) {
          ingedienceProv_items.add(e);
        }
      }
    }
    else {
      ingedienceProv_items = ingedienceProv.items;
    }

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children:  <Widget> [
            SizedBox(
              width: widget.width /3 - 20,
              child:
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
            ),
            const Spacer(),
            const Text("Alle Zusätze", style: TextStyle(color: Colors.grey, fontSize: 11),),
            const Spacer(),
            SizedBox(
              width: widget.width /3 - 20,
              child:
              const Divider(
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
          ingedienceProv_items.map((e) {
            int amountOfItemsAlreadyAdded = 0;
            for (var element in tableItemProvidor.added_ingredients) {
              if (element == e.id) {
                amountOfItemsAlreadyAdded ++;
              }
            }
            return GestureDetector(
                onTap: (){
                  setState((){
                    if(tableItemProvidor.paymode || tableItemProvidor.isFromServer()) return;
                    tableItemProvidor.added_ingredients.add(e.id);
                    tableItemProvidor.notify(context);
                  });
                },
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: amountOfItemsAlreadyAdded > 0 ? const Color(0xFFD3E03A) : Colors.transparent,
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
                        Text(e.name,
                          overflow: TextOverflow.ellipsis,
                          style: const
                        TextStyle(color: Colors.black,fontSize: 10),),
                        Text(e.price.toStringAsFixed(2) + "€", style: const
                        TextStyle(color: Colors.black,fontSize: 12, fontWeight: FontWeight.bold),),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                              children: List.generate(
                                  amountOfItemsAlreadyAdded,
                                      (index) => Padding(
                                      padding: const EdgeInsets.only(left: 3),
                                      child: Container(
                                        height: 3,
                                        width: 3,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                          BorderRadius.circular(5),
                                        ),

                                      )
                                  )
                              )
                          ),
                        ),
                      ]
                  ),
                )
            );
          }).toList(),
        ),
      ],
    );
  }
}
