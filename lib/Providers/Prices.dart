import 'package:flutter/widgets.dart';
import 'Category.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Models/Price.dart';

class Prices with ChangeNotifier {
  List<Price> _items = [];

  List<Price> get items {
    return [..._items];
  }

  Future<void> addPrices({required token}) async {
    // this function will add all Prices to the _items List
    final url = Uri.parse(
      'https://www.inspery.com/menu/all_prices/',
    );
    final headers = {"Authorization": "Token ${token}"};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      for (int i = 0; i < data.length; i++) {
        var pro = Price.fromJson(data[i]);
        _items.add(pro);
      }
    } else {
      print(
          'Request failed with status: ${response.statusCode}. menu/all_prices/');
    }
    notifyListeners();
  }

  Price findById(int id) {
    //this function will search for a Price by ID
    return _items.firstWhere((t) => t.id == id,
        orElse: () => Price(
              id: 0,
              price: 0,
            ));
  }
}
