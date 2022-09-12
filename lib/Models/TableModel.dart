import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:inspery_waiter/Providers/NotificationProvider.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../components/vibration.dart';
import '/Providers/TableItemsProvidor.dart';
import 'NotificationModel.dart';

class TableModel {
  List<NotificationModel> notifications = [];
  late final int id;
  final String name;
  double total_price;
  int? owner;
  final String type;
  Map<String, int> timeHistory = {};

  WebSocketChannel? _channel;
  late final _tIP = TableItemsProvidor(); //tIP = tableItemProvider
  TableItemsProvidor get tIP {
    return _tIP;
  }

  void addNotification({required notificationID, required context}){
    //TODO: in feature we could send the notifications in the table websocket
    notifications.add(Provider.of<NotificationProvider>(context, listen: false).notificationTypes.firstWhere((not) => not.id == notificationID));
    //for(int x = 0; x < 5; x++){
      Vibration.vibrate(pattern: [1000, 300, 1000, 300]);
    //}
    FlutterRingtonePlayer.playNotification();
    InAppNotification.show(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(notifications.last.name, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),),
            Text(notifications.last.msg, style: const TextStyle(fontSize: 18),),
          ],
        ),
      ),
      duration: const Duration(seconds: 4),
      context: context,
      onTap: () => print('Notification tapped!'),
    );
  }

  get channel {
    return _channel;
  }

  set channel(tableChannel) {
    _channel = tableChannel;
  }

  set tIP(items) {
    _tIP.setItems(items);
  }

  Future<void> sendItems(tB) async {
    _channel!.sink.add('{"command": "new_table_items","table_items": $tB}');
  }

  Future<void> closeSocket(tB) async {
    await _channel?.sink.close();
  }

  TableModel(
      {required this.id,
      required this.name,
      required this.total_price,
      required this.owner,
      required this.type});

  factory TableModel.fromJson(response) {
    var jsonResponse = response as Map<String, dynamic>;
    jsonResponse["type"] == null ? jsonResponse["type"] = 'null' : null;
    print(jsonResponse);
    return TableModel(
        name: jsonResponse["name"] as String,
        id: jsonResponse["id"] as int,
        owner:
            jsonResponse["owner"] == null ? null : jsonResponse["owner"] as int,
        type: jsonResponse["type"] as String,
        total_price: jsonResponse["total_price"].toDouble() as double);
  }
}
