import 'dart:convert';

import 'package:flutter/material.dart';

import 'Ingredient.dart';

class Product {
//this class is the product class
  late final int id;
  final String name;
  final List<int> price1;
  final List<int> allergien;
  final int side_product_number;
  //final String? description;
  //final String? product_pic;
  //final int category;
  final List<Ingredient> ingredients;
  final List<ProductPrice> product_price;
  final int dips_number;
  final List<int> side_products;

  Product({
    required this.product_price,
    required this.id,
    required this.name,
    required this.price1,
    required this.allergien,
    required this.ingredients,
    required this.side_product_number,
    required this.dips_number,
    required this.side_products,
  });

  factory Product.fromJson(response) {
    var jsonResponse = response as Map<String, dynamic>;
    return Product(
      name: jsonResponse["name"] as String,
      id: jsonResponse["id"] as int,
      price1: List<int>.from(jsonResponse["product_price"] as List<dynamic>),
      allergien: List<int>.from(jsonResponse["allergien"] as List<dynamic>),
      product_price: List.generate((jsonResponse["product_price"] as List<dynamic>).length, (index) => ProductPrice.fromJson((jsonResponse["product_price"] as List<dynamic>)[index])),
      //description: jsonResponse["description"] as String?,
      //product_pic: jsonResponse["product_pic"] as String?,
      side_product_number: (jsonResponse["side_products_number"]??0) as int,
      dips_number: jsonResponse["dips_number"] as int,
      side_products: List<int>.from(jsonResponse["side_products"] as List<dynamic>),
      //category: jsonResponse["category"] as int,
      ingredients: List.generate((jsonResponse["ingredients"] as List<dynamic>).length, (index) => Ingredient.fromJson((jsonResponse["ingredients"] as List<dynamic>)[index], context: context)),
    );
  }
}
