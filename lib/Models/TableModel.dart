import 'package:web_socket_channel/io.dart';
import '/Providers/TableItemsProvidor.dart';

class TableModel {
  late final int id;
  final String name;
  double total_price;
  int? owner;
  final String type;
  Map<String, int> timeHistory = {};

  IOWebSocketChannel? _channel;
  late final _tIP = TableItemsProvidor(); //tIP = tableItemProvider
  TableItemsProvidor get tIP {
    return _tIP;
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
