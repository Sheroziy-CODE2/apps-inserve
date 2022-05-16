import 'dart:convert';

import 'package:flutter/material.dart';

class Price {
//this class is the Price class
  late final int id;
  final double price;

  Price({
    required this.id,
    required this.price,
  });

  factory Price.fromJson(response) {
    var jsonResponse = response as Map<String, dynamic>;
    return Price(
      price: jsonResponse["price"] as double,
      id: jsonResponse["id"] as int,
    );
  }
}
