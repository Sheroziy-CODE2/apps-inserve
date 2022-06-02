
import 'package:inspery_pos/Models/Ingredient.dart';
import 'package:inspery_pos/Models/ProductPrice.dart';

import 'Ingredient.dart';

class Product {
  late final int id;
  final String name;
  final List<ProductPrice> product_price;
  final List<String> allergien;
  final int side_product_number;
  final List<Ingredient> ingredients;
  final int dips_number;
  final List<int> side_products;

  Product({
    required this.product_price,
    required this.id,
    required this.name,
    //required this.description,
    required this.allergien,
    required this.ingredients,
    required this.side_product_number,
    required this.dips_number,
    required this.side_products,
  });

  factory Product.fromJson(response, {required context}) {
    var jsonResponse = response as Map<String, dynamic>;
    return Product(
      id: jsonResponse["id"] as int,
      name: jsonResponse["name"] as String,
      allergien: List<String>.from(jsonResponse["allergien"] as List<dynamic>),
      product_price: List.generate((jsonResponse["product_price"] as List<dynamic>).length, (index) => ProductPrice.fromJson((jsonResponse["product_price"] as List<dynamic>)[index])),
      //description: jsonResponse["description"] as String?,
      //product_pic: jsonResponse["product_pic"] as String?,
      side_product_number: (jsonResponse["side_products_number"]??0) as int,
      dips_number: jsonResponse["dips_number"] as int,
      side_products: List<int>.from(jsonResponse["side_products"] as List<dynamic>),
      //category: jsonResponse["category"] as int,
      ingredients: List.generate((jsonResponse["ingredients"] as List<dynamic>).length, (index) => Ingredient.fromJson((jsonResponse["ingredients"] as List<dynamic>)[index], context: context)),
    );
  }
}
