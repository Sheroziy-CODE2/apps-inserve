import 'Ingredient.dart';
import 'ProductSelection.dart';
import 'ProductPrice.dart';

class Product {
  late final int id;
  final String name;
  final List<ProductPrice> product_price;
  final List<String> allergien;
  final List<Ingredient> ingredients;
  //final int dips_number;
  final List<ProductSelection> productSelection;

  Product(
      {required this.product_price,
      required this.id,
      required this.name,
      required this.allergien,
      required this.ingredients,
      //required this.dips_number,
      required this.productSelection});

  factory Product.fromJson(response, {required context}) {
    var jsonResponse = response as Map<String, dynamic>;
    return Product(
      id: jsonResponse["id"] as int,
      name: jsonResponse["name"],
      allergien: List<String>.from(jsonResponse["allergien"] as List<dynamic>),
      product_price: List.generate(
          (jsonResponse["product_price"] as List<dynamic>).length,
          (index) => ProductPrice.fromJson(
              (jsonResponse["product_price"] as List<dynamic>)[index])),
      //dips_number: jsonResponse["dips_number"] as int,
      ingredients: List.generate(
          (jsonResponse["ingredients"] as List<dynamic>).length,
          (index) => Ingredient.fromJson(
              (jsonResponse["ingredients"] as List<dynamic>)[index],
              context: context)),
      productSelection: List.generate(
          (jsonResponse["side_products"] as List<dynamic>).length,
          (index) => ProductSelection.fromJson(
              (jsonResponse["side_products"] as List<dynamic>)[index])),
    );
  }
}
