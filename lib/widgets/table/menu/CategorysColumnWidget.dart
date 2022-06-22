import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../../../Providers/Categorys.dart';
import '../../../Providers/Category.dart';

class CategorysColumn extends StatefulWidget {
  // this is the column of categorys in ChooseProductForm
  final Function categoryHandler;
  final String type;
  int id;
  ScrollController scrollController = ScrollController();
  final elementsShown = 6;
  //final String categorieID;

  CategorysColumn({
    Key? key,
    required this.id,
    required this.type,
    required this.categoryHandler,
    //required this.categorieID
  }) : super(key: key);

  @override
  State<CategorysColumn> createState() => CategorysColumnState();
}

class CategorysColumnState extends State<CategorysColumn> {

  int id = 0;
  bool rotate = true;
  int selectedIndex = -1;

  changeCategory(int id) {
    widget.categoryHandler(id);
  }
  double elementHight = 99;



  @override
  Widget build(BuildContext context) {
    id = widget.id;
    final categorysData = Provider.of<Categorys>(
      context,
    ); //category provider
    final categorieitems = categorysData.items.where((i) =>
    i.product_type == widget.type
    ).toList();



    try {
      final box = context.findRenderObject() as RenderBox;
      final hight = box.size.height;
      elementHight = ((hight-25) / widget.elementsShown)-10;
    } catch(e){
      print("Coud not get RenderBox to calculate the hight of the widget, error: " + e.toString());
      //Kann fehler verursachen!!! -> Loop

    }


    while(categorieitems.length % widget.elementsShown != 0){
      categorieitems.add(Category(id: -1, name: "Platzhalter", category_type: 0, product_type: '', picture: ''));
    }


    return GridTile(
      child: Container(
        padding: const EdgeInsets.only(top: 0, left: 1, right: 1, bottom: 60.0),
        child: Column(
          children: [
            SizedBox(
              height: 25,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Spacer(),
                  CircleAvatar(
                    radius: 5,
                    child: Container(),
                    backgroundColor:
                    selectedIndex == -1 ? const Color(0xFFD1D1D1) :
                    categorieitems[selectedIndex].id == id
                        ? const Color(0xFFD3E03A)
                        : const Color(0xFFD1D1D1),
                  ),
                  const SizedBox(width: 3,),
                  Text(
                    widget.type,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: selectedIndex == -1 ? const Color(0xFFD1D1D1) :
                      categorieitems[selectedIndex].product_type == widget.type
                          ? const Color(0xFF1B262C)
                          : const Color(0xFFD1D1D1),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Expanded(
              child:
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  int sensitivity = 8;
                  if (details.delta.dy > sensitivity) {
                    // Down Swipe
                    widget.scrollController.animateTo(
                        widget.scrollController.position.pixels - (elementHight*widget.elementsShown),
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.linear);
                  } else if(details.delta.dy < -sensitivity){
                    // Up Swipe
                    widget.scrollController.animateTo(
                        widget.scrollController.position.pixels + (elementHight*widget.elementsShown),
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.linear);
                  }
                },
                child: ListView.builder(
                    controller: widget.scrollController,
                    physics: const NeverScrollableScrollPhysics(), // <-- this will disable scroll
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
                    scrollDirection: Axis.vertical,
                    itemCount:categorieitems.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: elementHight,
                        child: categorieitems[index].id == -1 ? Container() :
                        GestureDetector(
                          onTap: () {
                            selectedIndex = index;
                            changeCategory(
                                categorieitems[index].id);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 1.5, left: 2.0, right: 2.0, bottom: 1.5),
                            decoration: BoxDecoration(
                              // border:
                              //     Border.all(color: Colors.blueAccent),
                              color:
                              categorieitems[index].id == id
                                  ? const Color(0xFFD3E03A)
                                  : const Color(0xFFD1D1D1),

                              boxShadow: const [],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            margin: const EdgeInsets.only(
                                top: 5.0, left: 7.5, right: 7.5, bottom: 5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                categorieitems[index].picture.isNotEmpty ?
                                widget.type == 'food' ? rotate
                                    ? Padding(padding: const EdgeInsets.only(right: 5, left: 5), child: Image.network(categorieitems[index].picture, width: 20, height: 20,),)
                                    : Container() : !rotate ? Padding(padding: const EdgeInsets.only(right: 5, left: 5), child: Image.network(categorieitems[index].picture, width: 20, height: 20,),) : Container() : Container(),

                                Expanded(
                                  child: Center(
                                    child: Text(
                                      categorieitems[index].name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF1B262C)
                                        /*widget.name == 'Getränke'
                                        ? drinks[index].id == id
                                            ? Color(0xFFF5F2E7)
                                            : Color(0xFF395B64)
                                        : food[index].id == id
                                            ? Color(0xFFF5F2E7)
                                            : Color(0xFF395B64),*/
                                      ),
                                    ),
                                  ),
                                ),
                                categorieitems[index].picture.isNotEmpty ?
                                widget.type == 'food' ? !rotate
                                    ?  Padding(padding: const EdgeInsets.only(right: 5, left: 5), child: Image.network(categorieitems[index].picture, width: 20, height: 20,),)
                                    : Container() : rotate ? Padding(padding: const EdgeInsets.only(right: 5, left: 5), child: Image.network(categorieitems[index].picture, width: 20, height: 20,),) : Container() : Container(),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
