
class InvoiceItem {
  late final int id;
  final double amount;
  final int quantity;
  final String product;
  final List side_products;
  final double price;
  final List<String> added_ingredients;
  final List<String> deleted_ingredients;

  InvoiceItem({
    required this.id,
    required this.amount,
    required this.quantity,
    required this.product,
    required this.side_products,
    required this.price,
    required this.added_ingredients,
    required this.deleted_ingredients,
  });

  factory InvoiceItem.fromJson(response) {
    var jsonResponse = response as Map<String, dynamic>;
    var data = jsonResponse['order'];
    return InvoiceItem(
      id: jsonResponse["id"] as int,
      amount: jsonResponse["amount"] as double,
      quantity: jsonResponse["quantity"] as int,
      product: data["product"] as String,
      side_products: data["side_products"] as List<dynamic>,
      price: data["selected_price"] as double,
      added_ingredients: data["added_ingredients"].cast<String>(),
      deleted_ingredients: data["deleted_ingredients"].cast<String>(),
    );
  }
}
