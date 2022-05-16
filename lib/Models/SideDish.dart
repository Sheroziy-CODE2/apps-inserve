import 'dart:convert';

import 'package:flutter/material.dart';

class SideDish {
//this class is the Side_dish class
  late final int id;
  final String name;
  final double main_price;
  final double secondary_price;

  SideDish({
    required this.id,
    required this.name,
    required this.main_price,
    required this.secondary_price,
  });

  factory SideDish.fromJson(response) {
    var jsonResponse = response as Map<String, dynamic>;
    return SideDish(
        name: jsonResponse["name"] as String,
        id: jsonResponse["id"] as int,
        main_price: jsonResponse["main_price"] as double,
        secondary_price: jsonResponse["secondary_price"] as double);
  }
}
