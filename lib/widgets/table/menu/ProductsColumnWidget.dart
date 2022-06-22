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
  final elementsShown = 7;



  @override
  State<ProductsColumn> createState() => ProductsColumnState();
}

class ProductsColumnState extends State<ProductsColumn> {
  ScrollController scrollController = ScrollController();
  TextEditingController editingController = TextEditingController();
  List<Product> products = [];
  String search = '';
  // var productsList = <Product>[];
  int get id => widget.id;
  double elementHight = 99;



  @override
  void initState() {
    super.initState();
    // productsList.addAll(duplicateItems);
    if (widget.id == 0) {
      setState(() {
        products = [];
      });
    } else {
      final categorysData = Provider.of<Categorys>(context, listen: false);
      final category = categorysData.
      findById(widget.id);
      setState(() {
        products = category.products;
      });
    }
  }

  void filterSearchResults(String query) {
    setState(() {
      search = query;
    });
    if (query != '') {
      List<Product> dummyListData = [];
      for (var item in products) {
        if (item.name.toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      }
      setState(() {
        products = [];
        products.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        final categorysData = Provider.of<Categorys>(context, listen: false);
        final category = categorysData.findById(widget.id);
        setState(() {
          products = category.products;
        });
      });
    }
  }

  // @override
  // void dispose() {
  //   try {
  //     Provider.of<TableItemChangeProvidor>(context, listen: false).showProduct(
  //         index: null, context: context);
  //   } catch(e){
  //     print("Error on Dispose when reset TableItemChangeProvider: " + e.toString());
  //   }
  //   super.dispose();
  // }

  // Category category = category;
  @override
  Widget build(BuildContext context) {


    try {
      final box = context.findRenderObject() as RenderBox;
      final hight = box.size.height;
      elementHight = ((hight) / widget.elementsShown)-10;
    } catch(e){
      print("Coud not get RenderBox to calculate the hight of the widget, error: " + e.toString());
      //Kann fehler verursachen!!! -> Loop
    }




    if(products.isNotEmpty){
      Future.delayed(const Duration(milliseconds: 50), () {
        scrollController.jumpTo(0);
      });
    }
    if (search == '') {
      setState(() {
        final categorysData = Provider.of<Categorys>(context, listen: false);
        final category = categorysData.findById(widget.id);
        setState(() {
          products = category.products;
        });
      });
    }
    List<Product> productsList = products;

    while(productsList.length % widget.elementsShown != 0){
      productsList.add(Product(product_price: [], id: 0, name: "Platzhalter", allergien: [], ingredients: [], dips_number: 0, productSelection: []));
    }


    return GridTile(
      child: Container(
        padding: const EdgeInsets.only(top: 0, left: 2, right: 2, bottom: 25.0),
        child: Column(
          children: [
            Container(
              height: 50,
              padding:
                  const EdgeInsets.only(top: 2, left: 8, right: 8, bottom: 2),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                textAlign: TextAlign.center,
                controller: editingController,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Color(0xFF1B262C))),
                  contentPadding: EdgeInsets.all(6),
                  fillColor: Color(0xFFF5F2E7),
                  focusColor: Color(0xFFF5F2E7),

                  labelText: "Suchen",
                  filled: true,
                  // labelTextColor: Colors.white,
                  hintText: "Suchen",
                  hintStyle: TextStyle(
                    color: Color(0xFF1B262C),
                    height: 2.8,
                  ),

                  // prefixIcon: Icon(Icons.search),
                  //   border: OutlineInputBorder(
                  //     borderSide: BorderSide(color: Colors.white, width: 10.0),
                  //     borderRadius: BorderRadius.all(
                  //       Radius.circular(5.0),
                  //     ),
                  //   ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  int sensitivity = 8;
                  if (details.delta.dy > sensitivity) {
                    // Down Swipe
                    scrollController.animateTo(
                        scrollController.position.pixels - (elementHight*widget.elementsShown),
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.linear);
                  } else if(details.delta.dy < -sensitivity){
                    // Up Swipe
                    scrollController.animateTo(
                        scrollController.position.pixels + (elementHight*widget.elementsShown),
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.linear);
                  }
                },
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(), // <-- this will disable scroll
                  controller: scrollController,
                  padding:
                      const EdgeInsets.only(top: 5, left: 0, right: 0, bottom: 0),
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
                        Provider.of<TableItemChangeProvidor>(context, listen: false)
                          .addProduct(context: context, productID: productsList[index].id, tableID: widget.tableID, refresh: false);
                        itemPos = itemList.getLength()-1;
                      }
                      itemList.editItemFromWaiter(context: context, itemPos: itemPos, product: productsList[index].id);
                      widget.goToNextPos(indicator: productsList[index].name, dontStoreIndicator: true, stay: true);
                    },
                    child: Container(
                      height: elementHight,
                      padding: const EdgeInsets.only(
                          top: 1.5, left: 2.0, right: 2.0, bottom: 1.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD3E03A),
                        boxShadow: const [],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: const EdgeInsets.only(
                          top: 4.0, left: 7.5, right: 7.5, bottom: 4.0),
                      child: Text(
                        productsList[index].name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF1B262C),
                        ),
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
