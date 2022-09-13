import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Models/Product.dart';
import '../../../Providers/TableItemChangeProvidor.dart';
import '../../../Providers/Tables.dart';
import '../../../screens/TablesViewScreen.dart';
import 'CategorysColumnWidget.dart';
import 'ProductsColumnWidget.dart';
import 'dart:math';

class ChooseProductForm extends StatefulWidget {
  // this form is to choose a product and add it as an order to the table!
  // it consists of 2 other widgets which are: ProductsColumnWidget and CategorysColumnWidget
  late List<Product> products;
  final int tableName;
  final Function goToNextPos;
  final String categorieTypeLeft;
  final String categorieTypeRight;
  ChooseProductForm({required this.tableName, required this.goToNextPos, required this.categorieTypeLeft, required this.categorieTypeRight, Key? key}) : super(key: key);

  @override
  State<ChooseProductForm> createState() => ChooseProductFormState();
}

class ChooseProductFormState extends State<ChooseProductForm> {
  // Category? category;
  int id = 0;
  bool rotate = false;
  final List<GlobalKey<CategorysColumnState>> list_key = List.generate(2, (index) => GlobalObjectKey<CategorysColumnState>(index*Random().nextInt(10000)));
  final GlobalKey<ProductsColumnState> singel_key = const GlobalObjectKey<ProductsColumnState>(987654321);


  changeCategory(int id) {
    Provider.of<TableItemChangeProvidor>(context, listen: false).categoryId = id;
    setState(() {
      this.id = id;
    });
  }


  @override
  Widget build(BuildContext context) {

    Tables tablesprov = Provider.of<Tables>(context, listen: true);
    final hight = MediaQuery.of(context).size.height / 2-10;
    return GestureDetector(
      onPanUpdate: (details) {
        updateListWidgets();
      },
      child: Stack(
        children: [
          AnimatedPositioned(
            //flex: 3,
            height: hight-15,
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
                  controlledWidget: singel_key,
                  key: list_key[0],
                  id: id,
                  type: widget.categorieTypeLeft,
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
            height: hight-35,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.34,
            left: MediaQuery
                .of(context)
                .size
                .width * 0.33,
            child: Column(
              children: [
                Expanded(
                  child: ProductsColumn(
                    key: singel_key,
                    id: id,
                    tableID: widget.tableName,
                    goToNextPos: widget.goToNextPos,
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    if(tablesprov.isItemFromWaiter(tableID: widget.tableName)){
                      tablesprov.checkoutItemsToSocket(context: context,tableID: widget.tableName);
                    } else{
                      Navigator.of(context).pushReplacementNamed(TablesView.routeName);
                    }
                  },
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color(0xFF818181),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: tablesprov.isItemFromWaiter(tableID: widget.tableName)
                        ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Übertragen", style: TextStyle(fontSize: 16 , color: Colors.white),),
                      ],
                    )
                        : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.arrow_back_ios, color:  Colors.white, size: 20,),
                        SizedBox(width: 5,),
                        Text("zurück", style: TextStyle(fontSize: 16 , color: Colors.white),),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            //flex: 3,
            height: hight-15,
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
                  controlledWidget: singel_key,
                  id: id,
                  key: list_key[1],
                  type: widget.categorieTypeRight,
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