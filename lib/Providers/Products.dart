import 'package:flutter/widgets.dart';
import '../Models/Product.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Future<void> addProducts({required token}) async {
    // this function will add all products to the _items List
    final url = Uri.parse(
      'https://www.inspery.com/menu/all_products/',
    );
    final headers = {"Authorization": "Token ${token}"};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      for (int i = 0; i < data.length; i++) {
        var pro = Product.fromJson(data[i]);
        _items.add(pro);
        //print("Product Name: " + pro.name + "  ID: " + pro.id.toString());
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    notifyListeners();
  }

  Product findById(int id) {
    //this function will search for a Product by ID
    final Product debug = _items.firstWhere((t) => t.id == id,
        orElse: () => Product(
              id: 0,
              name: '0',
              price1: [],
              side_dishes_number: 0,
              description: '',
              allergien: [],
              ingredients: [],
            ));
    return debug;
  }
}
