
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/FlorLayoutProvider.dart';
import '../../screens/TableViewScreen.dart';

class SingleFlorWidget extends StatefulWidget {
  final double drawnFlorSizeX;
  double drawnFlorSizeY;
  final int florNumber;
  SingleFlorWidget({required this.florNumber, required this.drawnFlorSizeX, required this.drawnFlorSizeY, Key? key}) : super(key: key);

  @override
  State<SingleFlorWidget> createState() => SingleFlorWidgetState();
}

class SingleFlorWidgetState extends State<SingleFlorWidget> {
  double y = 0;

  @override
  Widget build(BuildContext context) {
    final florProv = Provider.of<FlorLayoutProvider>(context, listen: true).items[widget.florNumber];
    if(y == 0) y = widget.drawnFlorSizeY;
    return  Container(
        width: widget.drawnFlorSizeX,
        height: y,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: florProv.color,
        ),
        //child: InteractiveViewer(
          child: Stack(
            children:[
              Stack( // Areas
                children: florProv.florAreaList.map((areas) =>
                    Positioned(
                      top: widget.drawnFlorSizeY*areas.y1,
                      left: widget.drawnFlorSizeX*areas.x1,
                      child: GestureDetector(
                        onTap: (){
                          print("Area: " + areas.name);
                        },
                        child: Container(
                          width: widget.drawnFlorSizeX*(areas.x2-areas.x1),
                          height: widget.drawnFlorSizeY*(areas.y2-areas.y1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: areas.color,
                          ),
                          child: Center(child: Text(areas.name, style: const TextStyle(fontSize: 10, color: Colors.white),)),
                        ),
                      ),
                    )
                ).toList(),
              ),
              Stack( //SquerTables
                children: florProv.florSquerTableList.map((squerTables) =>
                    Positioned(
                      top: widget.drawnFlorSizeY*squerTables.y1,
                      left: widget.drawnFlorSizeX*squerTables.x1,
                      child: GestureDetector(
                        onTap: (){
                          print("SquereTable: " + squerTables.tableID.toString());
                          Navigator.of(context).pushReplacementNamed(
                            TableView.routeName,
                            arguments: squerTables.tableID.toString(),
                          );
                        },
                        child: Container(
                          width: widget.drawnFlorSizeX*(squerTables.x2-squerTables.x1),
                          height: widget.drawnFlorSizeY*(squerTables.y2-squerTables.y1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: squerTables.color,
                          ),
                          child: squerTables.img != null ? Center(child: Image.network(squerTables.img!)) : null,
                        ),
                      ),
                    )
                ).toList(),
              ),
              Stack( //RoundTables
                children: florProv.florRoundTableList.map((roundTables) =>
                    Positioned(
                      top: widget.drawnFlorSizeY*roundTables.y-(widget.drawnFlorSizeX *roundTables.diameter/2),
                      left: widget.drawnFlorSizeX*roundTables.x-(widget.drawnFlorSizeX *roundTables.diameter/2),
                      child: GestureDetector(
                        onTap: (){
                          print("SquereTable: " + roundTables.tableID.toString());
                          Navigator.of(context).pushReplacementNamed(
                            TableView.routeName,
                            arguments: roundTables.tableID.toString(),
                          );
                        },
                        child: Container(
                          width: widget.drawnFlorSizeX * roundTables.diameter,
                          height: widget.drawnFlorSizeY * roundTables.diameter,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(widget.drawnFlorSizeX * roundTables.diameter/2),
                            color: roundTables.color,
                          ),
                          child: roundTables.img != null ? Center(child: Image.network(roundTables.img!)) : null,
                        ),
                      ),
                    )
                ).toList(),
              ),
              Positioned(child: Text(florProv.name, style: const TextStyle(fontSize: 10, color: Colors.white),),left: 5, bottom: 5,)
            ]
        ),
     // ),
    );
  }
}
