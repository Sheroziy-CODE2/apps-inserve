import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:inspery_pos/Providers/DipsProvider.dart';
import 'package:inspery_pos/Providers/Products.dart';
import 'package:inspery_pos/Providers/TableItemChangeProvidor.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'Ingredients.dart';
import 'TableItemProvidor.dart';

import 'Tables.dart';

class TableItemsProvidor with ChangeNotifier {
  List<TableItemProvidor> _tableItems = [];
  bool isLoading = false;
  bool hight_mode_extendet = false;

  List<TableItemProvidor> get tableItems {
    return [..._tableItems];
  }

  //late TableItemProvidor _tableItemInBuffer; //This is a item that is just in configuration

  int getTimeFromLastInputProduct(){
    int retunrTime = 0;
    for (var element in _tableItems) {
      if(retunrTime < element.date) retunrTime = element.date;
    }
    return retunrTime;
  }

  void delete(item) {
    _tableItems.remove(item);
  }

  void notify() {
    final _context = MyApp.navKey.currentContext;
    if(_context == null) {
      print("Global context in checkState on dispose TableOverviewFrame is null");
      return;
    }
    Provider.of<Tables>(_context, listen: false).notify();
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

  void deleteItemsFromServer({required amount, required itemID}) {
    TableItemProvidor item = _tableItems.firstWhere((t) => t.id == itemID);
    if (item.quantity - amount > 0) {
      item.changeInCard(amount);
    } else {
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

  void addItemFromWaiter({required TableItemProvidor newItem, bool refresh = true}) {
    print("Add item from Waiter to list");
    _tableItems.add(newItem);
    _tableItems.last.fromWaiter = true;
    if(refresh) {
      notifyListeners();
    }
  }

  int getItemLenth() {
    return _tableItems.length;
  }

  ///Set amount in card of all Items to zero
  void setItemsAmountToPayToZero({required context}) {
    for (int x = 0; x < _tableItems.length; x++) {
      _tableItems[x].zeroAmountInCard(context: context);
    }
    notify();
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
  void setItemsPaymode({required bool paymode}) {
    try {
      for (int x = 0; x < _tableItems.length; x++) {
        _tableItems[x].paymode = paymode;
      }
      //notify();
      notifyListeners();
    }
    catch(e){print("SetPaymode failed: " + e.toString());}
  }

  void setHightModeExtendet({required hight_mode_extendet}){
    this.hight_mode_extendet = hight_mode_extendet;
    notifyListeners();
  }

  ///returns the Product from a given position
  TableItemProvidor? getSingleTableItemProvidor({required int id}) {
    return _tableItems[id];
  }

  ///Adds quantity of product in a given position
  void addQuantity(
      {required int id, required int amountToAdd}) {
    _tableItems[id].quantity += amountToAdd;
    notifyListeners();
    notify();
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



  ///returns the total Price of a single Product
  double getTotalPriceOfProductByPos(
      {required context, required pos, bool paymode = false}) {
    double value = 0;
    var ingredientsProvidor = Provider.of<Ingredients>(context, listen: false);
    var productssProvidor = Provider.of<Products>(context, listen: false);
    var dipsProvidor = Provider.of<DipsProvider>(context, listen: false);

    try { //This can happen when there is no item in the list
      value += productssProvidor
          .findById(_tableItems[pos].product)
          .product_price
          .firstWhere((element) =>
      element.id == _tableItems[pos].selected_price).price;
    }catch(e){
      final priceList = productssProvidor
          .findById(_tableItems[pos].product)
          .product_price;
      if(priceList.where((element) => !element.isSD).isNotEmpty) {
        value += priceList.where((element) => !element.isSD).first.price;
      }
      else if(priceList.isNotEmpty){
        value += priceList.first.price;
      }
    }
    _tableItems[pos].dips.forEach((dip) {
      value += dipsProvidor.findById(dip).price;
    });

    _tableItems[pos].added_ingredients.forEach((inc) {
      value += ingredientsProvidor.findById(inc).price;
    });
    //var sideProductsProvidor = Provider.of<SideProducts>(context, listen: false);
    try{
    _tableItems[pos].side_product.forEach((sd) {
      value += productssProvidor.findById(sd).product_price.firstWhere((element) => element.isSD).price;
    });}
    catch(e){}
    if (paymode) {
      value *= _tableItems[pos].getAmountInCard();
    } else {
      value *= _tableItems[pos].quantity;
    }
    return value;
  }

  ///search for a specific price from ProductProvidor in given position
  double getSingleItemPriceByPos({required context, required pos}) {
    var productssProvidor = Provider.of<Products>(context, listen: false);
    return productssProvidor.findById(_tableItems[pos].product).product_price[_tableItems[pos].selected_price].price;
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
     Provider.of<TableItemChangeProvidor>(context, listen: false).showProduct(index: null, context: context);
    _tableItems.removeAt(pos);
    notifyListeners();
    notify();
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
      var jsonResponse = convert.jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
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


  void editItemFromWaiter({
    required context,
    required itemPos,
    int? quantity,
    int? saved_table,
    int? user,
    int? product,
    int? selected_price,
    int? date,
    List<int>? side_product,
    List<int>? added_ingredients,
    List<int>? deleted_ingredients,
  }){
    print("Item Pos");
    print(itemPos);
    print("Table Items");
    print(_tableItems);
    if(_tableItems[itemPos].isFromServer()){
      print("You are not allowed to Addid this item");
      return;
    }
    if(quantity != null){_tableItems[itemPos].quantity = quantity;}
    if(saved_table!= null){_tableItems[itemPos].saved_table = saved_table;}
    if(user!= null){_tableItems[itemPos].user = user;}
    if(product!= null){_tableItems[itemPos].product = product;}
    if(selected_price!= null){_tableItems[itemPos].selected_price = selected_price;}
    if(date!= null){_tableItems[itemPos].date = date;}
    if(side_product!= null){_tableItems[itemPos].side_product = side_product;}
    if(added_ingredients!= null){_tableItems[itemPos].added_ingredients = added_ingredients;}
    if(deleted_ingredients!= null){_tableItems[itemPos].deleted_ingredients = deleted_ingredients;}
    _tableItems[itemPos].fromWaiter = true;
    notify();
  }



}
