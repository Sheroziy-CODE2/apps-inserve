import 'package:flutter/widgets.dart';
import '../Models/Product.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../util/EnvironmentVariables.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Future<void> addProducts({required token, required context}) async {
    final url = Uri.parse(
      EnvironmentVariables.apiUrl+'menu/products/',
    );
    final headers = {"Authorization": "Token $token"};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(response.bodyBytes)));
      for (int i = 0; i < data.length; i++) {
        var pro = Product.fromJson(data[i], context: context);
        _items.add(pro);
        //print("Product Name: " + pro.name + "  ID: " + pro.id.toString());
      }
    } else {
      print('Products: Request failed with status: ${response.statusCode}.');
    }
    notifyListeners();
  }

  Product findById(int id) {
    final Product debug = _items.firstWhere((t) => t.id == id,
        orElse: () => Product(
              id: 0,
              name: '0',
              allergien: [],
              ingredients: [],
              product_price: [],
              productSelection: [],
            ));
    return debug;
  }

  Product findByName(String name) {
    final Product debug = _items.firstWhere((t) => t.name == name,
        orElse: () => Product(
              id: 0,
              name: '0',
              allergien: [],
              ingredients: [],
              product_price: [],
              productSelection: [],
            ));
    return debug;
  }
}
