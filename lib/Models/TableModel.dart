import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';

import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'package:inspery_pos/Providers/TableItemProvidor.dart';
import 'package:inspery_pos/Providers/TableItemsProvidor.dart';
import 'package:inspery_pos/Providers/Tables.dart';

class TableModel {
  late final int id;
  final String name;
  double total_price;
  final int owner;
  final String type;
  Map<String, num> timeHistory = {};

  bool _isInit = true;
  IOWebSocketChannel? _channel;
  late final _tIP = TableItemsProvidor(); //tIP = tableItemProvider
  TableItemsProvidor get tIP {
    return _tIP;
  }

  get channel {
    return _channel != null ? _channel : null;
  }

  void set channel(tableChannel) {
    this._channel = tableChannel;
  }

  void set tIP(items) {
    this._tIP.setItems(items);
  }

  Future<void> sendItems(tB) async {
    _channel!.sink.add(
        '{"command": "new_table_items","table_items": $tB}'); //send new table items to the socket
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

  // static fromJson(Map<String, dynamic> data) {}
  factory TableModel.fromJson(response) {
    var jsonResponse = response as Map<String, dynamic>;
    jsonResponse["type"] == null ? jsonResponse["type"] = 'null' : null;
    print(jsonResponse);
    return TableModel(
        name: jsonResponse["name"] as String,
        id: jsonResponse["id"] as int,
        owner: jsonResponse["owner"] as int,
        type: jsonResponse["type"] as String,
        total_price: jsonResponse["total_price"].toDouble() as double);
  }
}
