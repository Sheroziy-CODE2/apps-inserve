class ProductPrice{
  double price;
  String description;
  int id;
  bool isSD;
  ProductPrice({required this.price, required this.description, required this.id, required this.isSD});

  factory ProductPrice.fromJson(response) {
    var jsonResponse = response as Map<String, dynamic>;
    return ProductPrice(
      price: jsonResponse["price"] as double,
      description: jsonResponse["description"] as String,
      id: jsonResponse["id"] as int,
      isSD: (jsonResponse["description"] as String) == "SD",
    );
  }
}