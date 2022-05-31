

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Providers/Products.dart';
import '../../../Providers/TableItemChangeProvidor.dart';
import '../../../Providers/TableItemProvidor.dart';
import '../../../Providers/TableItemsProvidor.dart';
import '../../../Providers/Tables.dart';

class ChooseProductSize extends StatefulWidget {
  const ChooseProductSize({Key? key, required this.tableName, required this.goToNextPos}) : super(key: key);
  final int tableName;
  final Function goToNextPos;

  @override
  State<ChooseProductSize> createState() => _ChooseProductSizeState();
}

class _ChooseProductSizeState extends State<ChooseProductSize> {

  late TableItemProvidor tableItemProvidor;
  late TableItemsProvidor tIP;


  @override
  Widget build(BuildContext context) {
    var tableItemChangeProvidor = Provider.of<TableItemChangeProvidor>(context, listen: true);
    var productProvidor = Provider.of<Products>(context, listen: false);
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
      print("CPS coulden't get Ingredients: " + e.toString());
      return Container();
    }

    var productPro = productProvidor.findById(tableItemProvidor.product);

    if(productPro.side_products.length<2){
      widget.goToNextPos(indicator: productPro.product_price[productPro.side_products.first].description);
    }

    return Column(
      children: [
        const SizedBox(height: 15,),
        const Text("Choose Size", style: TextStyle(color: Colors.black,fontSize: 20,),),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.count(
            //physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: (1 / 1),
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            shrinkWrap: true,
            crossAxisCount: 5,
            children:
            productPro.product_price.map((price_item) {
              return GestureDetector(
                  onTap: (){
                    widget.goToNextPos(indicator: price_item.description);
                    tableItemProvidor.setSelectedPrice(context: context, new_selected_price: productPro.product_price.indexOf(price_item));
                  },
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: productPro.product_price.indexOf(price_item) == tableItemProvidor.selected_price! ? const Color(0xFFD3E03A) : Colors.transparent,
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
                          const Spacer(),
                          Text(price_item.description, style: const TextStyle(color: Colors.black,fontSize: 10, fontWeight: FontWeight.bold),),
                          Text(price_item.price.toStringAsFixed(2) + "€", style: const TextStyle(color: Colors.black,fontSize: 12,),),
                          const Spacer(),
                        ]
                    ),
                  )
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
