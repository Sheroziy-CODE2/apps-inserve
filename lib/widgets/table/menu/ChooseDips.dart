
import 'package:flutter/material.dart';
import 'package:inspery_pos/Providers/DipsProvider.dart';
import 'package:provider/provider.dart';

import '../../../Providers/Products.dart';
import '../../../Providers/TableItemChangeProvidor.dart';
import '../../../Providers/TableItemProvidor.dart';
import '../../../Providers/TableItemsProvidor.dart';
import '../../../Providers/Tables.dart';

class ChooseDips extends StatefulWidget {
  const ChooseDips({Key? key, required this.tableName, required this.goToNextPos}) : super(key: key);
  final int tableName;
  final Function goToNextPos;

  @override
  State<ChooseDips> createState() => _ChooseDipsState();
}

class _ChooseDipsState extends State<ChooseDips> {

  late TableItemProvidor tableItemProvidor;
  late TableItemsProvidor tIP;
  List<int> selected = [];


  @override
  Widget build(BuildContext context) {
    var tableItemChangeProvidor = Provider.of<TableItemChangeProvidor>(context, listen: true);
    var productProvidor = Provider.of<Products>(context, listen: false);
    var dipsProvidor = Provider.of<DipsProvider>(context, listen: false);
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
      print("CD coulden't get Table: " + e.toString());
      return const Center(child: Text('Dips Fehler'));
    }

    var productPro = productProvidor.findById(tableItemProvidor.product);


    return Column(
      children: [
        const SizedBox(height: 15,),
        Text("noch " + (productPro.dips_number - selected.length).toString() + " Dip"+(selected.length != 1 ? "":"s" )+ " wählen", style: const TextStyle(color: Colors.black,fontSize: 18,),),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.count(
            childAspectRatio: (1 / 1),
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            shrinkWrap: true,
            crossAxisCount: 5,
            children:
            dipsProvidor.items.map((dips) {
              return GestureDetector(
                  onTap: (){
                    if(selected.contains(dips.id)){
                      selected.remove(dips.id);
                    }
                    else{
                      if(selected.length == productPro.dips_number){
                        return;
                      }
                      selected.add(dips.id);
                    }
                    if(selected.length != productPro.dips_number){
                      setState(() {});
                      widget.goToNextPos(indicator: selected.length.toStringAsFixed(0) + (selected.length == 1 ? "x Dip" : "x Dips"),stay: true);
                      return;
                    }
                    widget.goToNextPos(indicator: selected.length.toStringAsFixed(0) + (selected.length == 1 ? "x Dip" : "x Dips"));
                    tableItemProvidor.setDips(context: context, new_dip: selected);
                  },
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: selected.contains(dips.id) ? const Color(0xFFD3E03A) : Colors.transparent,
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
                          Text(dips.name, overflow: TextOverflow.ellipsis, maxLines: 2, style: const TextStyle(color: Colors.black,fontSize: 10, fontWeight: FontWeight.bold),),
                          Text(dips.price.toStringAsFixed(2) + "€", style: const TextStyle(color: Colors.black,fontSize: 12,),),
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
