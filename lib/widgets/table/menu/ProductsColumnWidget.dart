import 'package:flutter/material.dart';
import '../../../Providers/Categorys.dart';
import '../../../Providers/TableItemChangeProvidor.dart';
import '../../../Models/Product.dart';
import 'package:provider/provider.dart';

import '../../../Providers/Tables.dart';

class ProductsColumn extends StatefulWidget {
  // this is the column of product in ChooseProductForm
  int id;
  final int tableID;
  final Function goToNextPos;

  ProductsColumn({required this.id, required this.tableID, required this.goToNextPos, Key? key}) : super(key: key);
  final elementsShown = 6;



  @override
  State<ProductsColumn> createState() => ProductsColumnState();
}

class ProductsColumnState extends State<ProductsColumn> {
  ScrollController scrollController = ScrollController();
  TextEditingController editingController = TextEditingController();
  List<Product> products = [];
  String search = '';
  // var productsList = <Product>[];
  double elementHight = 999;
  double hight = 400;
  Color color = Colors.orange;

  changeID({required int newID, required Color color}){
    setState((){
      widget.id = newID;
      this.color = color;
    });
  }



  // Category category = category;
  @override
  Widget build(BuildContext context) {
    products = [];

    if (widget.id != 0) {
      final categorysData = Provider.of<Categorys>(context, listen: false);
      final category = categorysData.findById(widget.id);
        products = category.products;
    }

      Future.delayed(const Duration(milliseconds: 30)).then((value) {
      try {
        final box = context.findRenderObject() as RenderBox;
        hight = box.size.height;
        elementHight = (hight / widget.elementsShown);
      } catch(e){
        //print("Coud not get RenderBox to calculate the hight of the widget, error: " + e.toString());
      }
      //setState((){});
    });




    if(products.isNotEmpty){
      Future.delayed(const Duration(milliseconds: 30), () {
        scrollController.jumpTo(0);
      });
    }
    List<Product> productsList = products;
    while(productsList.length % widget.elementsShown != 0){
      productsList.add(Product(product_price: [], id: 0, name: "Platzhalter", allergien: [], ingredients: [], productSelection: []));
    }
    return GridTile(
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                const int sensitivity = 20;
                if (details.delta.dy > sensitivity) {
                  // Down Swipe
                  print("Swipe Down " + (scrollController.position.pixels + hight).toString());
                  scrollController.animateTo(
                      scrollController.position.pixels - hight,
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.linear);
                } else if(details.delta.dy < -sensitivity){
                  // Up Swipe
                  print("Swipe Up " + (scrollController.position.pixels + hight).toString());
                  scrollController.animateTo(
                      scrollController.position.pixels + hight,
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.linear);
                }
              },
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(), // <-- this will disable scroll
                controller: scrollController,
                //padding: const EdgeInsets.only(top: 5, left: 0, right: 0, bottom: 0),
                scrollDirection: Axis.vertical,
                itemCount: productsList.length,
                itemBuilder: (context, index) =>
                productsList[index].name == "Platzhalter" ? Container(height: elementHight,) :
                    GestureDetector(
                  onTap: () {
                    final tip = Provider.of<TableItemChangeProvidor>(context, listen: false);
                    int? itemPos = tip.getActProduct();
                    var itemList = Provider.of<Tables>(context, listen: false).findById(widget.tableID).tIP;
                    if(itemPos == null) {
                      print(productsList[index].id.toString() + " " + productsList[index].name);
                      Provider.of<TableItemChangeProvidor>(context, listen: false)
                        .addProduct(context: context, productID: productsList[index].id, tableID: widget.tableID, refresh: false);
                      itemPos = itemList.getLength()-1;
                    }
                    itemList.editItemFromWaiter(context: context, itemPos: itemPos, product: productsList[index].id);
                    widget.goToNextPos(indicator: productsList[index].name, dontStoreIndicator: true, stay: true);
                  },
                  child: Container(
                    height: elementHight-8,
                    //padding: const EdgeInsets.only(top: 1.5, left: 2.0, right: 2.0, bottom: 1.5),
                    decoration: BoxDecoration(
                      color: color,
                      boxShadow: const [],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.only(top: 4.0, left: 7.5, right: 7.5, bottom: 4.0),
                    child: Center(
                      child: Text(
                        productsList[index].name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1B262C),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
