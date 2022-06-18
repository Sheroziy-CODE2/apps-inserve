import 'package:flutter/widgets.dart';
import 'Category.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Models/Product.dart';

class Categorys with ChangeNotifier {
  List<Category> _items = [];

  List<Category> get items {
    return [..._items];
  }

  Future<void> addProducts(cat, {required context}) async {
    //this function will get all the products for the category sent to it
    final url = Uri.parse(
      'https://www.inspery.com/menu/products/${cat.id}',
    );
    final headers = {"Content-type": "application/json"};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final productsData =
          List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(response.bodyBytes)));
      List<Product> proList = [];
      for (int i = 0; i < productsData.length; i++) {
        var p = Product.fromJson(productsData[i], context: context);
        proList.add(p);
      }
      cat.changePropducts(proList);
    } else {
      print(
          'Request failed with status: ${response.statusCode}. /menu/products/${cat.id}');
    }
    notifyListeners();
  }

  Future<void> addCategory({required context}) async {
    // this function will add categorys to the _items List
    final url = Uri.parse(
      'https://www.inspery.com/menu/category/4',
    );
    final headers = {"Content-type": "application/json"};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(response.bodyBytes)));
      for (int i = 0; i < data.length; i++) {
        var cat = Category.fromJson(data[i]);
        addProducts(
            //adding the products to the category we are saving
            cat,
            context: context);
        _items.add(cat);
      }
    } else {
      print(
          'Request failed with status: ${response.statusCode}. /menu/category/4');
    }
    notifyListeners();
  }

  Category findByType(String type) {
    //this function will search for a category by ID
    return _items.firstWhere((t) => t.product_type == type,
        orElse: () => Category(
              id: 0,
              name: '0',
              category_type: 0,
              product_type: '',
              picture: '',
              //type: null,
            ));
  }

  Category findById(int id) {
    //this function will search for a category by ID
    return _items.firstWhere((t) => t.id == id,
        orElse: () => Category(
              id: 0,
              name: '0',
              category_type: 0,
              product_type: '',
              picture: '',
              //type: null,
            ));
  }
}
