import 'package:flutter/widgets.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Models/SideDish.dart';

class SideDishes with ChangeNotifier {
  List<SideDish> _items = [];

  List<SideDish> get items {
    return [..._items];
  }

  Future<void> addSideDishes({required token}) async {
    // this function will add all SideDishes to the _items List
    final url = Uri.parse(
      'https://www.inspery.com/menu/side_dishes/',
    );
    final headers = {"Authorization": "Token ${token}"};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      for (int i = 0; i < data.length; i++) {
        var pro = SideDish.fromJson(data[i]);
        _items.add(pro);
      }
    } else {
      print(
          'Request failed with status: ${response.statusCode}. menu/all_SideDishes');
    }
    notifyListeners();
  }

  SideDish findById(int id) {
    //this function will search for a SideDish by ID
    return _items.firstWhere((t) => t.id == id,
        orElse: () => SideDish(
              id: 0,
              name: '',
              main_price: 0,
              secondary_price: 0,
            ));
  }
}
