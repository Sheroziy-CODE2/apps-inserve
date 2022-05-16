
import 'package:flutter/cupertino.dart';
import 'package:inspery_pos/Models/Product.dart';
import 'package:inspery_pos/Providers/Authy.dart';
import 'package:inspery_pos/Providers/SideDishes.dart';
import 'package:inspery_pos/Providers/TableItemProvidor.dart';
import 'package:provider/provider.dart';
import '../Models/SideDish.dart';
import '../Models/TableModel.dart';
import 'Products.dart';
import 'TableItemsProvidor.dart';
import 'Tables.dart';


class TableItemChangeProvidor extends ChangeNotifier {
  int? _productPosInItem;
  bool paymode = false;

  //Because we use only the Tabels Provider
  void notify({context}){
    Provider.of<Tables>(context, listen: false).notify();
  }

  ///Call this Function to add a Product to the TableItemsProvidor
  ///In Future it will not hand it directly to the Providor, it will do it via the Websocket
  addProduct({required context, required productID, required int tableID}){
    print("Add Item");
    // //TODO: Replace the next line with a Serverrequest when the WebSockets are implemented - Andi 30.03
     // Provider.of<TableItemsProvidor>(context, listen: false).addProduct(productID: productID, tableName: tableName);
    var tablesProvider = Provider.of<Tables>(context, listen: false);
    var procuct = Provider.of<Products>(context, listen:  false).findById(productID);
    _productPosInItem = tablesProvider.findById(tableID).tIP.getItemLenth();
    tablesProvider.findById(tableID).tIP.addItemFromWaiter(
        newItem:
        TableItemProvidor(
          product: productID,
          quantity: 1,
          table: tableID,
          price: procuct.price1.isNotEmpty ? procuct.price1.first : 0,
          side_dish: [procuct.side_dishes_number],
          saved_table: 0,
          deleted_ingredients: [],
          added_ingredients: [],
        ),
    );
    tablesProvider.notify();//Workarround beause we use only the Tables Providor
    notifyListeners();
  }

  ///Set this to true if you want to pay, false if you only want to see what is on the table in the TableOverviewProductList
  void setPaymode({required paymode, required context}){
    this.paymode = paymode;
    notify(context: context);
    notifyListeners();
  }

  bool getPaymode(){
    return paymode;
  }

  ///Call this Function to change the shown Product in the TableItemWidget
  ///It will not effect the data of any product
  showProduct({required index, required context}){
    _productPosInItem = index;
    notify(context: context);
    notifyListeners();
  }

  ///Call this Function to get all the ProductID from the givenProduct that is shown
  ///if it is null, no Product should be shown in the TableOverviewChangeProduct Widget
  int? getActProduct(){
    return _productPosInItem;
  }

}