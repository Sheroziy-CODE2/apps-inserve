import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

import 'Ingredients.dart';
import 'Prices.dart';
import 'SideDishes.dart';
import 'Tables.dart';

class TableItemProvidor with ChangeNotifier {
  final int id;
  late int quantity;
  //double total_price;
  late int table;
  int saved_table;
  int user;
  int product;
  int price;
  List<int> side_dish;
  List<int> added_ingredients;
  List<int> deleted_ingredients;

  bool fromWaiter = false;
  int _inCart = 0;
  bool paymode = false;

  //this function is needed because we use only one Providor anymore
  void notify(context) {
    print("Notify Tables Providor");
    Provider.of<Tables>(context, listen: false).notify();
  }

  ///Set this to true if you want to pay, false if you only want to see what is on the table in the TableOverviewProductList
  void setPaymode({required paymode, required context}) {
    this.paymode = paymode;
    notify(context);
    notifyListeners();
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
    if (_inCart > quantity) _inCart = quantity;
    notify(context);
    notifyListeners();
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
    if (quantity < 0) quantity = 0;
    notify(context);
    notifyListeners();
  }

  double getTotalPrice({required context, checkout}) {
    double value = 0;
    var ingredientsProvidor = Provider.of<Ingredients>(context, listen: false);
    var priceProvidor = Provider.of<Prices>(context, listen: false);
    var sideDishProvidor = Provider.of<SideDishes>(context, listen: false);
    value += priceProvidor.findById(price).price;
    added_ingredients.forEach((inc) {
      value += ingredientsProvidor.findById(inc).price;
    });
    side_dish.forEach((sd) {
      value += sideDishProvidor.findById(sd).secondary_price;
    });
    if (checkout ?? paymode) {
      value *= getAmountInCard();
    } else {
      value *= quantity;
    }
    return value;
  }

  String getExtrasWithSemicolon({required context}) {
    String ret = "";
    var sideDishProvidor = Provider.of<SideDishes>(context, listen: false);
    side_dish.forEach((element) {
      ret += sideDishProvidor.findById(element).name + ", ";
    });
    var ingredientsProvidor = Provider.of<Ingredients>(context, listen: false);
    added_ingredients.forEach((element) {
      ret += /* "+" + */ ingredientsProvidor.findById(element).name + ", ";
    });
    if(ret == ", ") ret = "";
    //deleted_ingredients.forEach((element) {
    //  ret += "-" + ingredientsProvidor.findById(element).name + ", ";
    //});
    return ret;
  }

  TableItemProvidor({
    this.id = 0,
    this.quantity = 0,
    this.table = 0,
    //this.total_price = 0.0,
    this.saved_table = 0,
    this.user = 0,
    this.product = 0,
    this.price = 0,
    this.side_dish = const [0],
    this.added_ingredients = const [0],
    this.deleted_ingredients = const [0],
  });

  factory TableItemProvidor.fromResponse(response) {
    var jsonResponse = response as Map<String, dynamic>;
    return TableItemProvidor(
      id: jsonResponse["id"] as int,
      quantity: jsonResponse["quantity"] as int,
      //total_price: jsonResponse["total_price"] as double,
      table: jsonResponse["table"] as int,
      saved_table: jsonResponse["saved_table"] as int,
      user: jsonResponse["user"] as int,
      product: jsonResponse["product"] as int,
      price: jsonResponse["price"] as int,
      side_dish: List<int>.from(jsonResponse["side_dish"] as List<dynamic>),
      added_ingredients:
          List<int>.from(jsonResponse["added_ingredients"] as List<dynamic>),
      deleted_ingredients:
          List<int>.from(jsonResponse["deleted_ingredients"] as List<dynamic>),
    );
  }

  void connectSocket({required id, required context, required token}) {
    // {required data}
    final _channel = IOWebSocketChannel.connect(
      Uri.parse(''), //TODO: Websocket URL hinzufügen
    );
    _channel.stream.listen(
      (message) {
        //TODO: Do something with da Data
        notifyListeners();
      },
      onError: (error) => print("Error Websocket TableItemProvidor: " + error),
    );
    _channel.sink.add(jsonEncode({"command": "fetch_table_items"}));
  }
}
