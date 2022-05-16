import 'package:flutter/widgets.dart';
import 'Category.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Models/Product.dart';

class Categorys with ChangeNotifier {
  List<Category> _items = [];

  List<Category> get items {
    return [..._items];
  }

  Future<void> addProducts(cat) async {
    //this function will get all the products for the category sent to it
    final url = Uri.parse(
      'https://www.inspery.com/menu/products/${cat.id}',
    );
    final headers = {"Content-type": "application/json"};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final productsData =
          List<Map<String, dynamic>>.from(jsonDecode(response.body));
      List<Product> proList = [];
      for (int i = 0; i < productsData.length; i++) {
        var p = Product.fromJson(productsData[i]);
        proList.add(p);
      }
      cat.changePropducts(proList);
    } else {
      print(
          'Request failed with status: ${response.statusCode}. /menu/products/${cat.id}');
    }
    notifyListeners();
  }

  Future<void> addCategory() async {
    // this function will add categorys to the _items List
    final url = Uri.parse(
      'https://www.inspery.com/menu/category/3',
    );
    final headers = {"Content-type": "application/json"};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      for (int i = 0; i < data.length; i++) {
        var cat = Category.fromJson(data[i]);
        addProducts(
          //adding the products to the category we are saving
          cat,
        );
        _items.add(cat);
      }
    } else {
      print(
          'Request failed with status: ${response.statusCode}. /menu/category/3');
    }
    notifyListeners();
  }

  Category findById(String id) {
    //this function will search for a category by ID
    return _items.firstWhere((t) => t.id.toString() == id,
        orElse: () => Category(
              id: 0,
              name: '0',
              category_type: 0,
            ));
  }
}