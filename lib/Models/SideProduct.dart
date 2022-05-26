

class SideProduct {
//this class is the Side_dish class
  final int id;
  final num price;
  final int product;

  SideProduct({
    required this.id,
    required this.price,
    required this.product,
  });

  factory SideProduct.fromJson(response) {
    var jsonResponse = response as Map<String, dynamic>;
    return SideProduct(
        id: jsonResponse["id"] as int,
        product: jsonResponse["product"] as int,
        price: jsonResponse["price"] as num,
    );
  }
}
