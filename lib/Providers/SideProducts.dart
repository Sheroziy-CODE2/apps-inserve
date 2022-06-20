//
// import 'package:flutter/widgets.dart';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../Models/SideProduct.dart';
//
// class SideProducts with ChangeNotifier {
//   List<SideProduct> _items = [];
//
//   List<SideProduct> get items {
//     return [..._items];
//   }
//
//   Future<void> addSideProducts({required token}) async {
//     // this function will add all SideDishes to the _items List
//     final url = Uri.parse(
//       'https://www.inspery.com/menu/side_products/',
//     );
//     final headers = {"Authorization": "Token ${token}"};
//     final response = await http.get(url, headers: headers);
//     if (response.statusCode == 200) {
//       final data = List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(response.bodyBytes)));
//       for (int i = 0; i < data.length; i++) {
//         var pro = SideProduct.fromJson(data[i]);
//         _items.add(pro);
//       }
//     } else {
//       print(
//           'Request failed with status: ${response.statusCode}. menu/side_products');
//     }
//     notifyListeners();
//   }
//
//   SideProduct findById(int id) {
//     //this function will search for a SideDish by ID
//     return _items.firstWhere((t) => t.id == id,
//         orElse: () => SideProduct(
//               id: 0, price: 0, product: 0,
//             ));
//   }
// }
