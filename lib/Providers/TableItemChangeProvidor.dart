import 'package:flutter/cupertino.dart';
import '/Models/ProductPrice.dart';
import '/Providers/TableItemProvidor.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'Products.dart';
import 'Tables.dart';

class TableItemChangeProvidor extends ChangeNotifier {
  int? _productPosInItem;
  bool paymode = false;
  bool selectedProcuctManual = false;
  int categoryId = 0;

  //Because we use only the Tabels Provider
  void notify({context}) {
    Provider.of<Tables>(context, listen: false).notify();
  }

  ///Call this Function to add a Product to the TableItemsProvidor
  ///In Future it will not hand it directly to the Providor, it will do it via the Websocket
  void addProduct(
      {required context,
      required productID,
      required int tableID,
      bool refresh = true}) {
    final tablesProvider = Provider.of<Tables>(context, listen: false);
    _productPosInItem = tablesProvider.findById(tableID).tIP.getItemLenth();
    var items = tablesProvider.findById(tableID).tIP;
    final selectedProduct =
        Provider.of<Products>(context, listen: false).findById(productID);
    //final user = Provider.of<Authy>(context, listen: false).userName;
    var selectedPriceOfProductID = 99;
    try {
      selectedPriceOfProductID = selectedProduct.product_price
          .firstWhere((element) => !element.isSD)
          .id;
    } catch (e) {
      ProductPrice pp = ProductPrice(
          price: 0.0,
          description: "keine größe angegeben",
          id: 99,
          isSD: false);
      selectedProduct.product_price.add(pp);
    }
    items.addItemFromWaiter(
      refresh: refresh,
      newItem: TableItemProvidor(
        to_go: false,
        product: productID,
        quantity: 1,
        table: tableID,
        selected_price: selectedPriceOfProductID,
        //saved_table: 0,
        deleted_ingredients: [],
        added_ingredients: [],
        date: (DateTime.now().microsecondsSinceEpoch / 1000).round(),
        user: 0,
        side_product: [],
        id: Random().nextInt(1000) + 1000,
      ),
    );
    if (refresh) {
      tablesProvider
          .notify(); //Workarround beause we use only the Tables Providor
      notifyListeners();
    }
  }

  ///Set this to true if you want to pay, false if you only want to see what is on the table in the TableOverviewProductList
  void setPaymode({required paymode, required context}) {
    this.paymode = paymode;
    notify(context: context);
    notifyListeners();
  }

  bool getPaymode() {
    return paymode;
  }

  ///Call this Function to change the shown Product in the TableItemWidget
  ///It will not effect the data of any product
  showProduct({required int? index, required context, bool toggle = false, bool selectedProcuctManual = false}) {
    this.selectedProcuctManual = selectedProcuctManual;
    if (index == null) {
      _productPosInItem = null;
      return;
    }
    try {
      if (toggle && _productPosInItem == index) {
        if (_productPosInItem != null)
          _productPosInItem = null;
        else
          _productPosInItem = index;
      } else {
        _productPosInItem = index;
      }
      notify(context: context);
      notifyListeners();
    } catch (e) {
      print("TableItemProvider showProduct: " + e.toString());
    }
  }

  ///Call this Function to get all the ProductID from the givenProduct that is shown
  ///if it is null, no Product should be shown in the TableOverviewChangeProduct Widget
  int? getActProduct() {
    return _productPosInItem;
  }
}
