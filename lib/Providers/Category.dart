import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import '../Models/Product.dart';

class Category extends ChangeNotifier {
  late final int id;
  final String name;
  final int category_type;
  List<Product> products = [];
  final String product_type;
  final String picture;

  Category({
    required this.id,
    required this.name,
    required this.category_type,
    required this.picture,
    required this.product_type,
  });

  changePropducts(productList) {
    this.products = productList;
  }

  factory Category.fromJson(response) {
    var jsonResponse = response as Map<String, dynamic>;
    return Category(
      name: jsonResponse["name"] as String,
      id: jsonResponse["id"] as int,
      category_type: jsonResponse["category_type"] as int,
      product_type: jsonResponse["products_type"],
      //type: jsonResponse["type"],
      picture: jsonResponse["picture"]??"",
    );
  }
}
