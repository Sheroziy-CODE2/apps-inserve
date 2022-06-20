
class WorkerModel {
  String username;
  int id;
  String profile;


  WorkerModel(
      {required this.username,
        required this.id,
        required this.profile});

  factory WorkerModel.fromJson(response, {required context}) {
    var jsonResponse = response as Map<String, dynamic>;
    return WorkerModel(
        username: jsonResponse["username"] as String,
        id: jsonResponse["id"] as int,
        profile:  jsonResponse["profile"] as String
    );
  }
}
