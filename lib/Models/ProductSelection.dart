

class ProductSelection {
  final List<int> products;
  final List<int> standard;
  final int number;
  final String name;

  ProductSelection({
    required this.products,
    required this.standard,
    required this.number,
    required this.name,
  });

  factory ProductSelection.fromJson(response) {
    var jsonResponse = response as Map<String, dynamic>;
    return ProductSelection(
      products: List<int>.from(jsonResponse["products"] as List<dynamic>),
      standard: List<int>.from(jsonResponse["standard"] as List<dynamic>),
      number: jsonResponse["number"] as int,
      name: jsonResponse["name"] ?? "Zusatz",
    );
  }
}