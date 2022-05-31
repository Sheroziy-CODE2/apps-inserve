class ProductPrice{
  double price;
  String description;
  ProductPrice({required this.price, required this.description});

  factory ProductPrice.fromJson(response) {
    var jsonResponse = response as Map<String, dynamic>;
    return ProductPrice(
      price: jsonResponse["price"] as double,
      description: jsonResponse["description"] as String,
    );
  }
}