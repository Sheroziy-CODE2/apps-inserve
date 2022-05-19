import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Ingredients.dart';
import 'Prices.dart';
import 'SideDishes.dart';
import 'TableItemProvidor.dart';

import 'Tables.dart';

class TableItemsProvidor with ChangeNotifier {
  List<TableItemProvidor> _tableItems = [];
  bool isLoading = false;
  bool hight_mode_extendet = false;

  List<TableItemProvidor> get tableItems {
    return [..._tableItems];
  }

  num getTimeFromLastInputProduct(){
    num retunrTime = 0;
    for (var element in _tableItems) {
      if(retunrTime < element.date) retunrTime = element.date;
    }
    return retunrTime;
  }

  void delete(item) {
    _tableItems.remove(item);
  }

  void notify({required context}) {
    Provider.of<Tables>(context, listen: false).notify();
  }

  void setItems(newItems) {
    _tableItems = newItems;
    notifyListeners();
  }

  void transfereTableItem({required newTable, required List<int> products, required context}){
    var destinyTable = Provider.of<Tables>(context, listen: false).findById(newTable);
    for(var product in products){
      var or = _tableItems.firstWhere((t) => t.id == product);
      //erste Table rein speichern
      if(or.saved_table == 0){
        _tableItems.firstWhere((t) => t.id == product).saved_table = or.table;
      }
      //ausschneiden
      destinyTable.tIP.addSingleProduct(
          //context: context,
          product: or,
      );
      //remove from old Table
      _tableItems.remove(or);
    }
  }

  void deleteItemsFromServer(q, pk) {
    // PK is primarykey ID
    // q is quantity 'how many should be deleted from the quantity'
    TableItemProvidor item = _tableItems.firstWhere((t) => t.id == pk);
    if (item.quantity - 1 > 0) {
      // ex: (4 water) - (3 water) = will have 1 water left
      item.changeInCard(1);
    } else {
      // ex: (4 water) - (4 water) = nothing left => delete everything
      delete(item);
    }
    notifyListeners();
  }

  void addItemsFromServer(newItems) {
    for (int i = 0; i < newItems.length; i++) {
      _tableItems.add(newItems[i]);
      _tableItems.last.fromWaiter = false;
    }
    notifyListeners();
  }

  void addItemFromWaiter({required TableItemProvidor newItem}) {
    print("Add item from Waiter to list");
    _tableItems.add(newItem);
    _tableItems.last.fromWaiter = true;
    notifyListeners();
  }

  int getItemLenth() {
    return _tableItems.length;
  }

  ///Set amount in card of all Items to zero
  void setItemsAmountToPayToZero({required context}) {
    for (int x = 0; x < _tableItems.length; x++) {
      _tableItems[x].zeroAmountInCard(context: context);
    }
    notify(context: context);
    notifyListeners();
  }

  ///Set amount in card of all Items to total value
  void setItemsAmountToPayToTotal({required context}) {
    for (int x = 0; x < _tableItems.length; x++) {
      _tableItems[x]
          .addAmountInCard(amount: _tableItems[x].quantity, context: context);
    }
    notifyListeners();
  }

  ///Set all Items in the TableOverviewProductItem Widget to paymode
  void setItemsPaymode({required bool paymode, required context}) {
    for (int x = 0; x < _tableItems.length; x++) {
      _tableItems[x].paymode = paymode;
    }
    notify(context: context);
    notifyListeners();
  }

  void setHightModeExtendet({required hight_mode_extendet, required context}){
    this.hight_mode_extendet = hight_mode_extendet;
    notify(context: context);
    notifyListeners();
  }

  ///returns the Product from a given position
  TableItemProvidor? getSingleTableItemProvidor({required int id}) {
    return _tableItems[id];
  }

  ///Adds quantity of product in a given position
  void addQuantity(
      {required int id, required int amountToAdd, required context}) {
    _tableItems[id].quantity += amountToAdd;
    notifyListeners();
    notify(context: context);
  }

  ///returns the total Price of all Products the given table
  double? getTotalOpenTablePrice({required context}) {
    double total = 0;
    for (int x = 0; x < _tableItems.length; x++) {
      total += getTotalPriceOfProductByPos(context: context, pos: x);
    }
    return total;
  }

  ///returns the total Price of Products in Cart of the given table
  double? getTotalCartTablePrice({required context}) {
    double total = 0;
    for (int x = 0; x < _tableItems.length; x++) {
      total +=
          getTotalPriceOfProductByPos(context: context, pos: x, paymode: true);
    }
    return total;
  }

  String getExtrasWithSemicolon({required context, required int pos}) {
    String ret = "";
    // var sideDishProvidor = Provider.of<SideDishes>(context, listen: false);
    // _tableItems[pos].side_dish.forEach((element) {
    //   ret += sideDishProvidor.findById(element.toString()).name + ", ";
    // });
    var ingredientsProvidor = Provider.of<Ingredients>(context, listen: false);
    _tableItems[pos].added_ingredients.forEach((element) {
      ret += "+" + ingredientsProvidor.findById(element).name + ", ";
    });
    _tableItems[pos].deleted_ingredients.forEach((element) {
      ret += "-" + ingredientsProvidor.findById(element).name + ", ";
    });
    return ret;
  }

  ///returns the total Price of a single Product
  double getTotalPriceOfProductByPos(
      {required context, required pos, bool paymode = false}) {
    double value = 0;
    var ingredientsProvidor = Provider.of<Ingredients>(context, listen: false);

    var priceProvidor = Provider.of<Prices>(context, listen: false);
    value += priceProvidor.findById(_tableItems[pos].price).price;
    _tableItems[pos].added_ingredients.forEach((inc) {
      value += ingredientsProvidor.findById(inc).price;
    });
    var sideDishProvidor = Provider.of<SideDishes>(context, listen: false);
    _tableItems[pos].side_dish.forEach((sd) {
      value += sideDishProvidor.findById(sd).secondary_price;
    });
    if (paymode) {
      value *= _tableItems[pos].getAmountInCard();
    } else {
      value *= _tableItems[pos].quantity;
    }
    return value;
  }

  ///search for a specific price from ProductProvidor in given position
  double getSingleItemPriceByPos({required context, required pos}) {
    var priceProvidor = Provider.of<Prices>(context, listen: false);
    return priceProvidor.findById(_tableItems[pos].price).price;
  }

  ///search for a specific OrderID from ProductProvidor in given position
  int getIDfromPos({required pos}) {
    return _tableItems[pos].id;
  }

  ///search for a specific ProductID from ProductProvidor in given position
  int getProductIDfromPos({required pos}) {
    return _tableItems[pos].product;
  }

  ///get to know how many Products are in the List
  int getLength() {
    return _tableItems.length;
  }

  ///Not yet implemented
  Future<void> changeTableOfProduct(
      {required List<int> productID,
      required int oldTable,
      required int newTable}) async {}

  ///add a singel Product do the Table
  void addSingleProduct({required TableItemProvidor product, /*required context*/}){
    _tableItems.add(product);
    //notify(context: context);
  }

  //remove a singel item
  void removeSingelProduct({required pos, required context}){
    _tableItems.removeAt(pos);
    notifyListeners();
    notify(context: context);
  }


  ///Override all Products with the Products from the Server
  Future<void> loadAllProduct({required String tableName}) async {
    //LISTS!
    final url = Uri.parse(
      'https://www.inspery.com/table/api/tablel_items/' + tableName,
    );
    final headers = {"Content-type": "application/json"};
    if (isLoading) return;
    isLoading = true;
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      _tableItems.clear();
      var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
      for (var body in jsonResponse) {
        _tableItems.add(TableItemProvidor.fromResponse(body));
      }
      isLoading = false;
      notifyListeners();
    } else {
      print(
          'TabelOverviewWidget: Request failed with status: ${response.statusCode}.');
    }
  }
}
