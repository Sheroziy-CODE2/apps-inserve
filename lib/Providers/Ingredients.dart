import 'package:flutter/widgets.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Models/Ingredient.dart';

class Ingredients with ChangeNotifier {
  List<Ingredient> _items = [];

  List<Ingredient> get items {
    return [..._items];
  }

  Future<void> addIngredients() async {
    // this function will add ingredients to the _items List
    final url = Uri.parse(
      'https://www.inspery.com/menu/ingriedients/',
    );
    final headers = {"Content-type": "application/json"};
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      for (int i = 0; i < data.length; i++) {
        var ing = Ingredient.fromJson(data[i]);
        _items.add(ing);
      }
    } else {
      print(
          'Request failed with status: ${response.statusCode}. menu/ingriedients/');
    }
    notifyListeners();
  }

  Ingredient findById(int id) {
    //this function will search for an ingredient by ID
    return _items.firstWhere((t) => t.id == id,
        orElse: () => Ingredient(
              id: 0,
              name: '0',
              price: 0,
            ));
  }
}
