
import 'package:flutter/material.dart';
import '/Models/ProductPrice.dart';
import 'package:provider/provider.dart';

import 'Ingredients.dart';
import 'Products.dart';
import 'Tables.dart';
import 'package:intl/intl.dart';

class TableItemProvidor with ChangeNotifier {
  final int id;
  late int quantity;
  //double total_price;
  late int table;
  bool to_go = false;
  //int saved_table;
  int status; // 0 waiting 1 preparing 2 done
  int? user;
  int product;
  int selected_price;
  int date;
  List<int> side_product;
  List<int> added_ingredients;
  List<int> deleted_ingredients;
  List<List<bool>>?
      selectetProductsInLine; // that is for SideProducts when they are not added to Server

  bool fromWaiter = false;
  int _inCart = 0;
  bool paymode = false;

  String getDateTime({String format = 'yyyy-MM-dd'}) {
    final DateFormat formatter = DateFormat(format);
    return formatter.format(DateTime.fromMillisecondsSinceEpoch(date * 1000));
  }

  //this function is needed because we use only one Providor anymore
  void notify(context) {
    print("Notify Tables Providor");
    Provider.of<Tables>(context, listen: false).notify();
  }

  ///Set this to true if you want to pay, false if you only want to see what is on the table in the TableOverviewProductList
  void setPaymode({required paymode, required context}) {
    this.paymode = paymode;
    notify(context);
  }

  void showSnackbar({required context, required String msg}) {
    final snackBar = SnackBar(
      content: Text(msg),
      // action: SnackBarAction(
      //   label: 'OK',
      //   onPressed: () {
      //     // Some code to undo the change.
      //   },
      // ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void setSelectedPrice({required context, required int new_selected_price}) {
    if (isFromServer()) {
      showSnackbar(context: context, msg: "Produkt gesprerrt!");
      return;
    }
    selected_price = new_selected_price;
    notify(context);
  }

  void setSideProducts({required context, required int new_side_product}) {
    if (isFromServer()) {
      showSnackbar(context: context, msg: "Produkt gesprerrt!");
      return;
    }
    side_product.add(new_side_product);
    notify(context);
  }


  void removeSideProducts({required context, required int side_pro}) {
    if (isFromServer()) {
      showSnackbar(context: context, msg: "Produkt gesprerrt!");
      return;
    }
    side_product.remove(side_pro);
    notify(context);
  }

  int getInCard() {
    return _inCart;
  }

  void changeInCard(int value) {
    // change the quantity of the product after payment
    _inCart = 0;
    quantity -= value;
  }

  bool getPaymode() {
    return paymode;
  }

  bool isFromWaiter() {
    return fromWaiter;
  }

  bool isFromServer() {
    return !fromWaiter;
  }

  void addAmountInCard({required int amount, required context}) {
    _inCart += amount;
    if (_inCart < 0) _inCart = 0;
    if (_inCart > quantity) _inCart = 0;
    notify(context);
  }

  void zeroAmountInCard({required context}) {
    _inCart = 0;
    notifyListeners();
    notify(context);
  }

  void maxAmountInCard({required context}) {
    _inCart = quantity;
    notify(context);
    notifyListeners();
  }

  int getAmountInCard() {
    return _inCart;
  }

  void addQuantity({required int amountToAdd, required context}) {
    quantity += amountToAdd;
    if (quantity < 1) quantity = 1;
    notify(context);
    notifyListeners();
  }

  double getTotalPrice({required context, checkout}) {
    var productProvidor = Provider.of<Products>(context, listen: false);
    List<ProductPrice> productPriceList =
        productProvidor.findById(product).product_price;
    double value = 0;
    if (productPriceList.isNotEmpty) {
      try {
        value += productPriceList
            .firstWhere((element) => element.id == selected_price)
            .price;
      } catch(e){
        print("ProductPricelist for Product: " + productProvidor.findById(product).name + " don't contain " + selected_price.toString() +"! Error: " + e.toString());
      }
    }

    var ingredientsProvidor = Provider.of<Ingredients>(context, listen: false);

    for (var inc in added_ingredients) {
      value += ingredientsProvidor.findById(inc).price;
    }
    for (var sp in side_product) {
      try {
        //this try case while in backend not all products contain a "SD"-Price
        value += productProvidor
            .findById(sp)
            .product_price
            .firstWhere((element) => element.isSD)
            .price;
      } catch (e) {
        print("Missing SD-Preise for Product: " +
            productProvidor.findById(sp).name);
      }
    }
    if (checkout ?? paymode) {
      value *= getAmountInCard();
    } else {
      value *= quantity;
    }
    return value;
  }

  String getExtrasWithSemicolon({required context}) {
    String ret = "";
    var productProvidor = Provider.of<Products>(context, listen: false);
    var productPro = productProvidor.findById(product);
    try {
      ret += productPro.product_price
              .firstWhere((element) => element.id == selected_price)
              .description +
          ", ";
    } catch (e) {
      ret += "keine Gr????e,";
    }

    for (var element in side_product) {
      ret += productProvidor.findById(element).name + ", ";
    }

    var ingredientsProvidor = Provider.of<Ingredients>(context, listen: false);
    added_ingredients.forEach((element) {
      ret += /* "+" + */ ingredientsProvidor.findById(element).name + ", ";
    });
    if (ret == ", ") ret = "";
    return ret;
  }

  TableItemProvidor({
    this.to_go = false,
    this.id = 0,
    this.quantity = 0,
    this.table = 0,
    //this.total_price = 0.0,
   // this.saved_table = 0,
    this.status = 0,
    this.user = 0,
    this.product = 0,
    this.selected_price = 0,
    this.side_product = const [],
    this.added_ingredients = const [],
    this.deleted_ingredients = const [],
    this.date = 0,
  });

  factory TableItemProvidor.fromResponse(response, {required int tableID}) {
    var jsonResponse = response as Map<String, dynamic>;
    if(jsonResponse["selected_price"] == null) print("FAILED ID: " + (jsonResponse["id"].toString()));
    return TableItemProvidor(
      to_go: jsonResponse["to_go"] as bool,
      id: jsonResponse["id"] as int,
      quantity: jsonResponse["quantity"] as int,
      //total_price: jsonResponse["total_price"] as double,
      table: tableID,//jsonResponse["table"] as int,
      //saved_table: jsonResponse["saved_table"] as int,
      user: jsonResponse["user"],
      product: jsonResponse["product"] as int,
      status: jsonResponse["status"] as int,
      selected_price: jsonResponse["selected_price"] as int,
      side_product:
          List<int>.from(jsonResponse["side_products"] as List<dynamic>),
      added_ingredients:
          List<int>.from(jsonResponse["added_ingredients"] as List<dynamic>),
      deleted_ingredients:
          List<int>.from(jsonResponse["deleted_ingredients"] as List<dynamic>),
      date: jsonResponse["date"],
    );
  }
}
