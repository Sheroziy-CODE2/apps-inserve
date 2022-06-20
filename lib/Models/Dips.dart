class Dips {
  late final int id;
  final double price;
  final String name;
  //final int restaurant;
  //final int category;

  Dips({
    required this.id,
    required this.price,
    required this.name,
  });

  factory Dips.fromJson(response) {
    var jsonResponse = response as Map<String, dynamic>;
    return Dips(
      price: jsonResponse["price"] as double,
      id: jsonResponse["id"] as int,
      name: (jsonResponse["name"] as String).replaceAll("[^A-Za-z0-9]", ""),
    );
  }
}
