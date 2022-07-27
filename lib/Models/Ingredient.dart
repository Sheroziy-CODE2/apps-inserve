
import 'package:provider/provider.dart';
import '../Providers/Ingredients.dart';

class Ingredient {
  late final int id;
  final String name;
  final double price;
  final String? ingredient_type;

  Ingredient({
    required this.id,
    required this.name,
    required this.price,
    required this.ingredient_type,
  });

  factory Ingredient.fromJson(response, {required context}) {
    try{
      var jsonResponse = response as int;
      return Provider.of<Ingredients>(context, listen: false).findById(jsonResponse);
    } catch(e){}

    var jsonResponse = response as Map<String, dynamic>;
    return Ingredient(
        ingredient_type: jsonResponse["ingredient_type"] as String?,
        name: (jsonResponse["name"] as String).replaceAll("[^A-Za-z0-9]", ""),
        id: jsonResponse["id"] as int,
        price: jsonResponse["price1"] as double);
  }
}
