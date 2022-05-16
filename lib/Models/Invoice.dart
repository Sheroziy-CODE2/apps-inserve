import 'dart:convert';

import 'package:flutter/material.dart';

class Invoice {
//this class is the Invoice class
  late final int id;
  final String date;
  final double amount;
  final int table;

  Invoice({
    required this.id,
    required this.date,
    required this.amount,
    required this.table,
  });

  factory Invoice.fromJson(response) {
    var jsonResponse = response as Map<String, dynamic>;
    return Invoice(
        date: jsonResponse["date"] as String,
        id: jsonResponse["id"] as int,
        amount: jsonResponse["amount"] as double,
        table: jsonResponse["table"] as int);
  }
}
