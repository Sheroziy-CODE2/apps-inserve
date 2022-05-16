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

  CategorysColumn({
    required this.id,
    required this.name,
    required this.categoryHandler,
  });

  @override
  State<CategorysColumn> createState() => _CategorysColumnState();
}

class _CategorysColumnState extends State<CategorysColumn> {
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
    final drinks =
        categorysData.items.where((i) => i.category_type == 2).toList();
    ; //drinks category items
    final food =
        categorysData.items.where((i) => i.category_type != 2).toList();
    ; //drinks category items-
    // final String id = ModalRoute.of(context)?.settings.arguments as String;
    final tablData = Provider.of<Tables>(context, listen: false);
    int id = widget.id.toInt();
    return GridTile(
      child: Container(
        padding: const EdgeInsets.only(top: 0, left: 1, right: 1, bottom: 5.0),
        child: Column(
          children: [
            Text(
              widget.name,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 5,
              child: Container(),
            ),
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.only(top: 5, left: 0, right: 0, bottom: 0),
                scrollDirection: Axis.vertical,
                itemCount:
                    widget.name == 'Drinks' ? drinks.length : food.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    changeCategory(
                        widget.name == 'Drinks' ? drinks[index] : food[index]);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 1.5, left: 2.0, right: 2.0, bottom: 1.5),
                    decoration: BoxDecoration(
                      // border:
                      //     Border.all(color: Colors.blueAccent),
                      color: widget.name == 'Drinks'
                          ? drinks[index].id == id
                              ? Color(0xFF395B64)
                              : Color(0xFFF5F2E7)
                          : food[index].id == id
                              ? Color(0xFF395B64)
                              : Color(0xFFF5F2E7),

                      boxShadow: const [],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.only(
                        top: 5.0, left: 7.5, right: 7.5, bottom: 5.0),
                    child: Text(
                      widget.name == 'Drinks'
                          ? drinks[index].name
                          : food[index].name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: widget.name == 'Drinks'
                            ? drinks[index].id == id
                                ? Color(0xFFF5F2E7)
                                : Color(0xFF395B64)
                            : food[index].id == id
                                ? Color(0xFFF5F2E7)
                                : Color(0xFF395B64),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
