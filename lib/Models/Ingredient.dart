import 'dart:convert';

import 'package:flutter/material.dart';

class Ingredient {
//this class is the Ingredient class
  late final int id;
  final String name;
  final double price;

  Ingredient({
    required this.id,
    required this.name,
    required this.price,
  });

  factory Ingredient.fromJson(response) {
    var jsonResponse = response as Map<String, dynamic>;
    return Ingredient(
        name: jsonResponse["name"] as String,
        id: jsonResponse["id"] as int,
        price: jsonResponse["price1"] as double);
  }
}
