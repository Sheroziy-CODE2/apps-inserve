import 'dart:convert' as convert;

class WaiterModel {
  String username;
  num id;
  String email;
  String token;

  WaiterModel(
      {required this.username,
      required this.id,
      required this.email,
      required this.token});

  factory WaiterModel.fromResponse(response) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return WaiterModel(
        username: jsonResponse["user"]["username"] as String,
        id: jsonResponse["user"]["id"] as num,
        email: jsonResponse["user"]["email"] as String,
        token: jsonResponse["token"] as String);
  }
}
