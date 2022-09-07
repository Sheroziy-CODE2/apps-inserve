

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
  bool fromServer = true;


  @override
  Widget build(BuildContext context) {
    var tableItemChangeProvidor = Provider.of<TableItemChangeProvidor>(context, listen: false);
    var productProvidor = Provider.of<Products>(context, listen: false);
    try {
      tIP = Provider
          .of<Tables>(context, listen: true)
          .findById(widget.tableName)
          .tIP;
      final int x = tableItemChangeProvidor.getActProduct()!;
      tableItemProvidor = tIP.tableItems[x];
      fromServer = tableItemProvidor.isFromServer();
    }
    catch (e){
      print("Table ID: " + widget.tableName.toString());
      print("CSP coulden't get Table: " + e.toString());
      return const Center(child: Text('Zusatz Fehler'));
    }

    var productPro = productProvidor.findById(tableItemProvidor.product);
    int maxSelected = 0;
    for (var element in productPro.productSelection) {
      maxSelected += element.number;
    }

    // if from server
    if(fromServer) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("gewählte "+(tableItemProvidor.side_product.length != 1 ? "Zusatz":"Zusätze" ), style: const TextStyle(color: Colors.black,fontSize: 18,),),
            const SizedBox(height: 20,),
            GridView.count(
              //physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: (2 / 1),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              shrinkWrap: true,
              crossAxisCount: 3,
              children:
              tableItemProvidor.side_product.map((sideProductID) {
                var product = productProvidor.findById(sideProductID);
                return Container(
                  decoration: BoxDecoration(
                    color: tableItemProvidor.side_product.contains(sideProductID) ? const Color(0xFFD3E03A) : Colors.transparent,
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
                        Text(product.product_price.firstWhere((element) => element.isSD).price.toStringAsFixed(2) + " €", style: const TextStyle(color: Colors.black,fontSize: 12,),),
                        const Spacer(),
                      ]
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    }

    if(tableItemProvidor.selectetProductsInLine == null){
      tableItemProvidor.selectetProductsInLine = List.generate(productPro.productSelection.length, (index1) =>
          List.generate(productPro.productSelection[index1].products.length, (index) {
            if(productPro.productSelection[index1].standard.contains(productPro.productSelection[index1].products[index])){
              return true;
            }
            return false;
          }
          )
      );
      for( int x = 0; x < tableItemProvidor.selectetProductsInLine!.length; x++){
        for( int y = 0; y < tableItemProvidor.selectetProductsInLine![x].length; y++){
          if(tableItemProvidor.selectetProductsInLine![x][y]) {
            tableItemProvidor.setSideProducts(context: context, new_side_product: productPro.productSelection[x].products[y]);
          }
        }
      }
    }


    return Column(
      children: [Padding(
          padding: const EdgeInsets.all(20.0),
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Wähle noch " + productPro.productSelection[0].number.toString() +"x " +productPro.productSelection[0].name, textAlign: TextAlign.left),
              ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (_,index) => Text("Wähle noch " + productPro.productSelection[index+1].number.toString()+"x " + productPro.productSelection[index+1].name),
                itemCount: productPro.productSelection.length,
                itemBuilder: (_, indexList) =>

                    GridView.count(
                      //physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: (2 / 1),
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      children:
                      List.generate(productPro.productSelection[indexList].products.length, (index) {
                        //productPro.productSelection[indexList].products.map((sideProductID) {
                        var productSD = productProvidor.findById(productPro.productSelection[indexList].products[index]);
                        return GestureDetector(
                            onTap: (){
                              if(!tableItemProvidor.selectetProductsInLine![indexList][index]){
                                //so it should get true now;
                                if(productPro.productSelection[indexList].number > tableItemProvidor.selectetProductsInLine![indexList].where((element) => element).length){
                                  tableItemProvidor.selectetProductsInLine![indexList][index] = true;
                                  tableItemProvidor.setSideProducts(context: context, new_side_product: productPro.productSelection[indexList].products[index]);
                                }
                                else{ // because when you can not select one, you should also not go to the next page
                                  return;
                                }
                              }
                              else {
                                tableItemProvidor.selectetProductsInLine![indexList][index] = false;
                                tableItemProvidor.removeSideProducts(context: context, side_pro: productPro.productSelection[indexList].products[index]);
                                //return;
                              }
                              int amountTrue = 0;
                              for (var elementX in tableItemProvidor.selectetProductsInLine!) {
                                amountTrue += elementX.where((element) => element).length;
                              }
                              if(maxSelected == amountTrue){
                                widget.goToNextPos(indicator: amountTrue.toStringAsFixed(0) + (amountTrue == 1 ? "x Zusatz" : "x Zusätze"));
                              }
                              setState((){});
                            },
                            child: Container(
                              height: 10,
                              decoration: BoxDecoration(
                                color: tableItemProvidor.selectetProductsInLine![indexList][index] ? const Color(0xFFD3E03A) : Colors.transparent,
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
                                    Text(productSD.name, overflow: TextOverflow.ellipsis, maxLines: 2, style: const TextStyle(color: Colors.black,fontSize: 10, fontWeight: FontWeight.bold),),
                                    Text(productSD.product_price.firstWhere((element) => element.isSD).price.toStringAsFixed(2) + " €", style: const TextStyle(color: Colors.black,fontSize: 12,),),
                                    const Spacer(),
                                  ]
                              ),
                            )
                        );
                      }).toList(),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
