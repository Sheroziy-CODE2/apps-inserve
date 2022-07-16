import 'package:flutter/material.dart';

import 'IngredientsGridView.dart';

class HorizontalAlphabetGridviewControllerWidget extends StatefulWidget {
  HorizontalAlphabetGridviewControllerWidget({Key? key, required this.gridViewKey}) : super(key: key);

  //GridviewGlobalKey
  final GlobalKey<IngredientsGridViewState> gridViewKey;
  final alphabet = ["#","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"];

  @override
  _horizontalAlphabetGridviewControllerWidgetState createState() => _horizontalAlphabetGridviewControllerWidgetState();
}

class _horizontalAlphabetGridviewControllerWidgetState extends State<HorizontalAlphabetGridviewControllerWidget> {

  int position = -1;
  double widgetWith = 1;
  final double hight = 45;

  @override
  Widget build(BuildContext context) {

    if(widgetWith == 1) {
      Future.delayed(const Duration(milliseconds: 50), () {
        try {
          final box = context.findRenderObject() as RenderBox;
          final width = box.size.width;
          widgetWith = width / widget.alphabet.length;
        } catch(e){
          //print("Coud not get RenderBox to calculate the width of the widget, error: " + e.toString());
          widgetWith = 10.0;
        }
        try {
          setState(() {});
        }
        catch(e){}
      });
    }

    return
    SizedBox(
        height: hight,
        child:Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child:  Row(
                  children:
                  List.generate(widget.alphabet.length, (index) =>
                      Column(
                        children: [
                          Container(
                            width: widgetWith,
                            decoration: BoxDecoration(
                              color: index == position ? Colors.black : Colors.transparent,
                              //border: index == position ? Border.all(color: const Color(0xFFD3E03A), width: 3) : null,
                              borderRadius: const BorderRadius.all(Radius.circular(15.0) //
                              ),
                            ),
                            child: Center(
                                child: Text(
                                  widget.alphabet[index],
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: index != position ? Colors.black : Colors.white,),)),
                          ),
                        ],
                      ),
                  )
              ),
            ),
            position == -1 ? Container() :
            Positioned(
              bottom: 0,
              left: position * widgetWith - widgetWith/2,
              child: SizedBox(
                width: widgetWith,
                child: Icon(Icons.arrow_circle_up, size: widgetWith*2),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: GestureDetector(
                onDoubleTap: (){
                  setState(() {
                    position = 0;
                    widget.gridViewKey.currentState!.setFilterLetter(filterLetter: widget.alphabet[position]);
                  });
                },
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    position = (details.globalPosition.dx.floorToDouble()/widgetWith).round();
                  });
                  try {
                    widget.gridViewKey.currentState!.setFilterLetter(filterLetter: widget.alphabet[position]);
                  }catch(e){
                    print("Key is not valid for IGV: " + e.toString());
                  }
                  //this.dYPoint = '${details.globalPosition.dy.floorToDouble()}';
                },
                child:Container(
                  color: Colors.transparent, //experienced errors without it, don't know why
                  width: widgetWith* widget.alphabet.length,
                  height: hight,),
              ),
            ),
          ],
        ),
      );
  }
}

