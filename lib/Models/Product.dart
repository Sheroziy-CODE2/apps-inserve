import 'dart:convert';

import 'package:flutter/material.dart';

class Product {
//this class is the product class
  late final int id;
  final String name;
  final List<int> price1;
  final List<int> allergien;
  final int side_dishes_number;
  final List<int> ingredients;
  final String? description;

  Product({
    required this.id,
    required this.name,
    required this.price1,
    required this.description,
    required this.allergien,
    required this.ingredients,
    required this.side_dishes_number,
  });

  factory Product.fromJson(response) {
    var jsonResponse = response as Map<String, dynamic>;
    return Product(
      name: jsonResponse["name"] as String,
      id: jsonResponse["id"] as int,
      price1: List<int>.from(jsonResponse["product_price"] as List<dynamic>),
      description: jsonResponse["description"] as String?,
      allergien: List<int>.from(jsonResponse["allergien"] as List<dynamic>),
      ingredients: List<int>.from(jsonResponse["ingredients"] as List<dynamic>),
      side_dishes_number: jsonResponse["side_dishes_number"] as int,
    );
  }
}