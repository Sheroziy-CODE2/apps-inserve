import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Models/Product.dart';
import 'CategorysColumnWidget.dart';
import '../../../../Providers/Category.dart';
import 'ProductsColumnWidget.dart';

class ChooseProductForm extends StatefulWidget {
  // this form is to choose a product and add it as an order to the table!
  // it consists of 2 other widgets which are: ProductsColumnWidget and CategorysColumnWidget
  late List<Product> products;
  final int tableName;
  ChooseProductForm({required this.tableName});

  @override
  State<ChooseProductForm> createState() => _ChooseProductFormState();
}

class _ChooseProductFormState extends State<ChooseProductForm> {
  ScrollController _controller = new ScrollController();
  Category? category;
  int id = 0;
  bool rotate = false;

  changeCategory(category) {
    setState(() {
      category = category;
    });
    setState(() {
      id = category.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hight = MediaQuery.of(context).size.height / 2 - 50;
    return Stack(
      children: [
        AnimatedPositioned(
          //flex: 3,
          height: hight,
          width: MediaQuery.of(context).size.width * 0.33,
          left: rotate ? 0 : MediaQuery.of(context).size.width * 0.66,
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
          child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  rotate = !rotate;
                });
              },
              child: CategorysColumn(
                  id: id, name: 'Drinks', categoryHandler: changeCategory)),
        ),
        Positioned(
          //flex: 4,
          height: hight,
          width: MediaQuery.of(context).size.width * 0.34,
          left: MediaQuery.of(context).size.width * 0.33,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                rotate = !rotate;
              });
            },
            child: ProductsColumn(
              id: id,
              tableID: widget.tableName,
            ),
          ),
        ),
        AnimatedPositioned(
          //flex: 3,
          height: hight,
          width: MediaQuery.of(context).size.width * 0.33,
          left: rotate ? MediaQuery.of(context).size.width * 0.67 : 0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
          child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  rotate = !rotate;
                });
              },
              child: CategorysColumn(
                  name: 'Food', id: id, categoryHandler: changeCategory)),
        ),
      ],
    );
  }
}
