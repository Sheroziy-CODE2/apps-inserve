import 'dart:convert';
import 'dart:ffi';

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
  final String product;
  final List side_products;
  final double price;
  final List<int> added_ingredients;
  final List<int> deleted_ingredients;
  final List<int> dips;

  // todo
  //side dish // products

  InvoiceItem({
    required this.id,
    // required this.date,
    required this.amount,
    required this.quantity,
    required this.product,
    required this.side_products,
    required this.price,
    required this.added_ingredients,
    required this.deleted_ingredients,
    required this.dips,
  });

  factory InvoiceItem.fromJson(response) {
    var jsonResponse = response as Map<String, dynamic>;
    var data = jsonResponse['order'];
    return InvoiceItem(
      // date: jsonResponse["date"] as String,
      id: jsonResponse["id"] as int,
      amount: jsonResponse["amount"] as double,
      quantity: jsonResponse["quantity"] as int,
      product: data["product"] as String,
      side_products: data["side_products"] as List<dynamic>,
      price: data["selected_price"]["price"] as double,
      added_ingredients: data["added_ingredients"].cast<int>(),
      deleted_ingredients: data["deleted_ingredients"].cast<int>(),
      dips: data["dips"].cast<int>(),
    );
  }
}
