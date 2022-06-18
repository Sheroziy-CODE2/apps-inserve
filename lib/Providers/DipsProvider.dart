import 'package:flutter/widgets.dart';
import '../Models/Dips.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DipsProvider with ChangeNotifier {
  List<Dips> _items = [];

  List<Dips> get items {
    return [..._items];
  }

  Future<void> addDips({required token, required context}) async {
    final url = Uri.parse(
      'https://www.inspery.com/menu/all_dips/',
    );
    final headers = {"Authorization": "Token ${token}"};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(response.bodyBytes)));
      for (int i = 0; i < data.length; i++) {
        var pro = Dips.fromJson(data[i]);
        _items.add(pro);
      }
    } else {
      print('Dips: Request failed with status: ${response.statusCode}.');
    }
    notifyListeners();
  }


  Dips findById(int id) {
    return _items.firstWhere((t) => t.id == id,
        orElse: () => Dips(
          id: 0,
          name: '0',
          price: 0.0,
        ));
  }
}
