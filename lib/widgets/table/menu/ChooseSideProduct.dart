
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Providers/Products.dart';
import '../../../Providers/TableItemChangeProvidor.dart';
import '../../../Providers/TableItemProvidor.dart';
import '../../../Providers/TableItemsProvidor.dart';
import '../../../Providers/Tables.dart';

class ChooseSideProduct extends StatefulWidget {
  const ChooseSideProduct({Key? key, required this.tableName, required this.goToNextPos}) : super(key: key);
  final int tableName;
  final Function goToNextPos;

  @override
  State<ChooseSideProduct> createState() => _ChooseSideProductState();
}

class _ChooseSideProductState extends State<ChooseSideProduct> {

  late TableItemProvidor tableItemProvidor;
  late TableItemsProvidor tIP;
  List<int> selected = [];


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
      print("CSP coulden't get Table: " + e.toString());
      return const Center(child: Text('Beilagen Fehler'));
    }

    var productPro = productProvidor.findById(tableItemProvidor.product);


    return Column(
      children: [
        const SizedBox(height: 15,),
        Text("noch " + (productPro.side_product_number - selected.length).toString() + " Beilage"+(selected.length != 1 ? "":"n" )+ " wählen", style: const TextStyle(color: Colors.black,fontSize: 18,),),
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
            productPro.side_products.map((sideProductID) {
              var product = productProvidor.findById(sideProductID);
              return GestureDetector(
                  onTap: (){
                    if(selected.contains(sideProductID)){
                      selected.remove(sideProductID);
                    }
                    else{
                      if(selected.length == productPro.side_product_number){
                        return;
                      }
                      selected.add(sideProductID);
                    }
                    if(selected.length != productPro.side_product_number){
                      setState(() {});
                      widget.goToNextPos(indicator: selected.length.toStringAsFixed(0) + (selected.length == 1 ? "xBeilage" : "xBeilagen"),stay: true);
                      return;
                    }
                    widget.goToNextPos(indicator: selected.length.toStringAsFixed(0) + (selected.length == 1 ? "xBeilage" : "xBeilagen"));
                    tableItemProvidor.setSideProducts(context: context, new_side_product: selected);
                  },
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: selected.contains(sideProductID) ? const Color(0xFFD3E03A) : Colors.transparent,
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
                          Text(product.name, overflow: TextOverflow.ellipsis, maxLines: 2, style: const TextStyle(color: Colors.black,fontSize: 10, fontWeight: FontWeight.bold),),
                          Text(product.product_price.firstWhere((element) => element.isSD).price.toStringAsFixed(2) + "€", style: const TextStyle(color: Colors.black,fontSize: 12,),),
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
