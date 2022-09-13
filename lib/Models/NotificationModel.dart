
class NotificationModel {
  late final int id;
  final String name;
  final String msg;
  final String? imagePath;
  final String type;

  NotificationModel({
    required this.name,
    required this.id,
    required this.imagePath,
    required this.msg,
    required this.type,
  });

  factory NotificationModel.fromJson(response, {required context}) {
    var jsonResponse = response as Map<String, dynamic>;
    return NotificationModel(
      id: jsonResponse["id"] as int,
      type: jsonResponse["type"] == null ? "" : jsonResponse["type"] as String,
      name: jsonResponse["name"] as String,
      msg: jsonResponse["msg"] as String,
      imagePath: jsonResponse["icon"] != null ? "https://www.inspery.com" + jsonResponse["icon"] : null,
    );
  }
}
