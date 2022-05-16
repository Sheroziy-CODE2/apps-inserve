import 'package:flutter/material.dart';
import '../../../Providers/Categorys.dart';
import '../../../Providers/TableItemChangeProvidor.dart';
import '../../../Models/Product.dart';
import 'package:provider/provider.dart';

class ProductsColumn extends StatefulWidget {
  // this is the column of product in ChooseProductForm
  final int id;
  final int tableID;

  ProductsColumn({required this.id, required this.tableID});

  @override
  State<ProductsColumn> createState() => _ProductsColumnState();
}

class _ProductsColumnState extends State<ProductsColumn> {
  TextEditingController editingController = TextEditingController();
  List<Product> products = [];
  String search = '';
  // var productsList = <Product>[];
  int get id => widget.id;
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
      final category = categorysData.findById(widget.id.toString());
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
      products.forEach((item) {
        if (item.name.toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        products = [];
        products.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        final categorysData = Provider.of<Categorys>(context, listen: false);
        final category = categorysData.findById(widget.id.toString());
        setState(() {
          products = category.products;
        });
      });
    }
  }

  // Category category = category;
  @override
  Widget build(BuildContext context) {
    if (search == '') {
      setState(() {
        final categorysData = Provider.of<Categorys>(context, listen: false);
        final category = categorysData.findById(widget.id.toString());
        setState(() {
          products = category.products;
        });
      });
    }
    List<Product> productsList = this.products;
    ;
    return GridTile(
      child: Container(
        padding: const EdgeInsets.only(top: 0, left: 2, right: 2, bottom: 5.0),
        child: Column(
          children: [
            Container(
              height: 50,
              padding:
                  const EdgeInsets.only(top: 7, left: 8, right: 8, bottom: 0.0),
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

                  labelText: "Search",
                  filled: true,
                  // labelTextColor: Colors.white,
                  hintText: "Search",
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
              child: ListView.builder(
                padding:
                    const EdgeInsets.only(top: 5, left: 0, right: 0, bottom: 0),
                scrollDirection: Axis.vertical,
                itemCount: productsList.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Provider.of<TableItemChangeProvidor>(context, listen: false)
                        .addProduct(
                            context: context,
                            productID: productsList[index].id,
                            tableID: widget.tableID);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 1.5, left: 2.0, right: 2.0, bottom: 1.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF395B64),
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
                        color: Color(0xFFF5F2E7),
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
