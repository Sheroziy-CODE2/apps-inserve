import 'dart:convert';

import 'package:flutter/material.dart';
import 'Ingredient.dart';
import 'Product.dart';
import './Ingredient.dart';

class InvoiceItem {
//this class is the InvoiceItem class
  late final int id;
  // final String date;
  final double amount;
  final int quantity;
  final int product;
  final List sideDish;
  final int price;
  final List<int> added_ingredients;
  final List<int> deleted_ingredients;

  // todo
  //side dish // products

  InvoiceItem({
    required this.id,
    // required this.date,
    required this.amount,
    required this.quantity,
    required this.product,
    required this.sideDish,
    required this.price,
    required this.added_ingredients,
    required this.deleted_ingredients,
  });

  factory InvoiceItem.fromJson(response) {
    var jsonResponse = response as Map<String, dynamic>;
    var jR_order_item = jsonResponse['order_item'];
    final data = Map<String, dynamic>.from(jsonDecode(jR_order_item));

    return InvoiceItem(
      // date: jsonResponse["date"] as String,
      id: jsonResponse["id"] as int,
      amount: jsonResponse["amount"] as double,
      quantity: jsonResponse["quantity"] as int,
      product: data['fields']["product"] as int,
      sideDish: data['fields']["side_dish"] as List<dynamic>,
      price: data['fields']["price"] as int,
      added_ingredients: data['fields']["added_ingredients"].cast<int>(),
      deleted_ingredients: data['fields']["deleted_ingredients"].cast<int>(),
    );
  }
}
