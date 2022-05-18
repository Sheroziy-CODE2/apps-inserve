import "package:flutter/material.dart";
import '../../../Providers/Tables.dart';
import '../../../screens/TableViewScreen.dart';
import 'package:provider/provider.dart';

import '../../../Models/TableModel.dart';
import '../../../Providers/Categorys.dart';
import '../../../Providers/Category.dart';

class CategorysColumn extends StatefulWidget {
  // this is the column of categorys in ChooseProductForm
  String name = 'categorys';
  final Function categoryHandler;
  int id = 0;
  ScrollController scrollController = ScrollController();
  final elementsShown = 6;

  CategorysColumn({
    Key? key,
    required this.id,
    required this.name,
    required this.categoryHandler,
  }) : super(key: key);

  @override
  State<CategorysColumn> createState() => CategorysColumnState();
}

class CategorysColumnState extends State<CategorysColumn> {

  bool rotate = true;
  int selectedIndex = -1;

  Category? pressedCategpry;
  changeCategory(category) {
    setState(() {
      pressedCategpry = category;
    });
    pressedCategpry = category;
    widget.categoryHandler(category);
  }

  @override
  Widget build(BuildContext context) {
    final categorysData = Provider.of<Categorys>(
      context,
    ); //category provider
    final drinks = categorysData.items.where((i) => i.category_type == 2).toList();
    //drinks category items
    final food = categorysData.items.where((i) => i.category_type != 2).toList();
    //drinks category items-
    // final String id = ModalRoute.of(context)?.settings.arguments as String;
    final tablData = Provider.of<Tables>(context, listen: false);
    int id = widget.id.toInt();

    Widget icon = widget.name == 'Getränke' ? const Icon(Icons.local_drink_outlined) : const Icon(Icons.set_meal_rounded);


     late final double elementHight;
    try {
      final box = context.findRenderObject() as RenderBox;
      final hight = box.size.height;
      elementHight = ((hight-25) / widget.elementsShown)-10;
    } catch(e){
      print("Coud not get RenderBox to calculate the higt of the widget, error: " + e.toString());
      elementHight = 43.0;
    }


    while(drinks.length % widget.elementsShown != 0){
      drinks.add(Category(id: -1, name: "Platzhalter", category_type: 0));
    }
    while(food.length % widget.elementsShown != 0){
      food.add(Category(id: -1, name: "Platzhalter", category_type: 0));
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
                    widget.name == 'Getränke'
                        ? drinks[selectedIndex].id == id
                        ? const Color(0xFFD3E03A)
                        : const Color(0xFFD1D1D1)
                        : food[selectedIndex].id == id
                        ? const Color(0xFFD3E03A)
                        : const Color(0xFFD1D1D1),
                  ),
                  const SizedBox(width: 3,),
                  Text(
                    widget.name,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: selectedIndex == -1 ? const Color(0xFFD1D1D1) :
                      widget.name == 'Getränke'
                          ? drinks[selectedIndex].id == id
                          ? const Color(0xFF1B262C)
                          : const Color(0xFFD1D1D1)
                          : food[selectedIndex].id == id
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
                    print("Down " + widget.scrollController.position.pixels.toString());
                    widget.scrollController.animateTo(
                        widget.scrollController.position.pixels - (elementHight*widget.elementsShown),
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.bounceInOut);
                  } else if(details.delta.dy < -sensitivity){
                    // Up Swipe
                    print("Up " + widget.scrollController.position.pixels.toString());
                    widget.scrollController.animateTo(
                        widget.scrollController.position.pixels + (elementHight*widget.elementsShown),
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.bounceInOut);
                  }
                },
              child: ListView.builder(
                controller: widget.scrollController,
                  physics: const NeverScrollableScrollPhysics(), // <-- this will disable scroll
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
                  scrollDirection: Axis.vertical,
                  itemCount:
                  widget.name == 'Getränke' ? drinks.length : food.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: elementHight,
                      child: (widget.name == 'Getränke' ? drinks[index].id == -1 :  food[index].id == -1) ? Container() :
                        GestureDetector(
                        onTap: () {
                          selectedIndex = index;
                          changeCategory(
                              widget.name == 'Getränke'
                                  ? drinks[index]
                                  : food[index]);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 1.5, left: 2.0, right: 2.0, bottom: 1.5),
                          decoration: BoxDecoration(
                            // border:
                            //     Border.all(color: Colors.blueAccent),
                            color: widget.name == 'Getränke'
                                ? drinks[index].id == id
                                ? const Color(0xFFD3E03A)
                                : const Color(0xFFD1D1D1)
                                : food[index].id == id
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
                              widget.name == 'Getränke' ? rotate
                                  ? icon
                                  : Container() : !rotate ? icon : Container(),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    widget.name == 'Getränke'
                                        ? drinks[index].name
                                        : food[index].name,
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
                              widget.name == 'Getränke' ? !rotate
                                  ? icon
                                  : Container() : rotate ? icon : Container(),
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
