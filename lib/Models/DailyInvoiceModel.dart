class DailyIncoiveModel{
  final int id;
  final DateTime date;
  final int user;
  final int restaurant;
  final num sum;
  final num cash;
  final num card;
  final num cash_tip;
  final num card_tip;

  DailyIncoiveModel({
    required this.id,
    required this.date,
    required this.user,
    required this.restaurant,
    required this.sum,
    required this.cash,
    required this.card,
    required this.cash_tip,
    required this.card_tip,
  });


  factory DailyIncoiveModel.fromJson(response) {
    var jsonResponse = response as Map<String, dynamic>;
    return DailyIncoiveModel(
      id: jsonResponse["daiyl_invoice"]["id"] as int,
      date: DateTime.fromMillisecondsSinceEpoch(jsonResponse["daiyl_invoice"]["date"] as int),
      user: jsonResponse["daiyl_invoice"]["user"] as int,
      restaurant: jsonResponse["daiyl_invoice"]["restaurant"] as int,
      sum: jsonResponse["sum"] as num,
      cash: jsonResponse["cash"] as num,
      card: jsonResponse["card"] as num,
      cash_tip: jsonResponse["cash_tip"] as num,
      card_tip: jsonResponse["card_tip"] as num,
    );
  }
}