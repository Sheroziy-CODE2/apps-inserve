import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Models/Product.dart';
import 'CategorysColumnWidget.dart';
import '../../../../Providers/Category.dart';
import 'ProductsColumnWidget.dart';
import 'dart:math';

class ChooseProductForm extends StatefulWidget {
  // this form is to choose a product and add it as an order to the table!
  // it consists of 2 other widgets which are: ProductsColumnWidget and CategorysColumnWidget
  late List<Product> products;
  final int tableName;
  final Function goToNextPos;
  final String categorieIDLeft;
  final String categorieIDRight;
  ChooseProductForm({required this.tableName, required this.goToNextPos, required this.categorieIDLeft, required this.categorieIDRight});

  @override
  State<ChooseProductForm> createState() => _ChooseProductFormState();
}

class _ChooseProductFormState extends State<ChooseProductForm> {
  Category? category;
  String id = "food";
  bool rotate = false;
  final List<GlobalKey<CategorysColumnState>> list_key = List.generate(
      2, (index) => GlobalObjectKey<CategorysColumnState>(index*Random().nextInt(100)));



  changeCategory(category) {
    setState(() {
      id = category.id;
    });
  }

  @override
  Widget build(BuildContext context) {

    final hight = MediaQuery
        .of(context)
        .size
        .height / 2 -20;
    return GestureDetector(
      onPanUpdate: (details) {
        updateListWidgets();
      },
      child: Stack(
        children: [
          AnimatedPositioned(
            //flex: 3,
            height: hight,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.33,
            left: rotate ? 0 : MediaQuery
                .of(context)
                .size
                .width * 0.66,
            duration: const Duration(milliseconds: 400),
            curve: Curves.fastOutSlowIn,
            child:
            Stack(
              children: [
                CategorysColumn(
                    key: list_key[0],
                    id: id,
                    name: 'Getränke',
                    //categorieID: widget.categorieIDLeft,
                    categoryHandler: changeCategory,
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 25,
                  child: GestureDetector(
                    onTap: () {
                      updateListWidgets();
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF818181),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(Icons.compare_arrows),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            //flex: 4,
            height: hight,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.34,
            left: MediaQuery
                .of(context)
                .size
                .width * 0.33,
            child: ProductsColumn(
              id: id,
              tableID: widget.tableName,
              goToNextPos: widget.goToNextPos,
            ),
          ),
          AnimatedPositioned(
            //flex: 3,
            height: hight,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.33,
            left: rotate ? MediaQuery
                .of(context)
                .size
                .width * 0.67 : 0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.fastOutSlowIn,
            child: Stack(
              children: [
                CategorysColumn(
                    key: list_key[1],
                    id: id,
                    name: 'Speisen',
                  //categorieID: widget.categorieIDRight,
                    categoryHandler: changeCategory,
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 25,
                  child: GestureDetector(
                    onTap: () {
                      updateListWidgets();
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF818181),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(Icons.compare_arrows),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  void updateListWidgets() {
    list_key[0].currentState!.rotate = rotate;
    list_key[0].currentState!.setState(() {});
    list_key[1].currentState!.rotate = rotate;
    list_key[1].currentState!.setState(() {});
    setState(() {
      rotate = !rotate;
    });
  }
}