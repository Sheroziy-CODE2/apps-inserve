

import 'dart:ui';

import 'package:flutter/material.dart';

class FlorLayoutModel{
  int id;
  List<FlorAreaModel> florAreaList;
  List<FlorRoundTableModel> florRoundTableList;
  List<FlorSquerTableModel> florSquerTableList;
  Color color;
  String name;
  double size_x;
  double size_y;

  FlorLayoutModel({
    required this.color,
    required this.id,
    required this.florAreaList,
    required this.florRoundTableList,
    required this.florSquerTableList,
    required this.name,
    required this.size_x,
    required this.size_y,
  });

  factory FlorLayoutModel.fromJson(response) {
    var jsonResponse = response as Map<String, dynamic>;
    return FlorLayoutModel(
      color: jsonResponse["color"] as Color,
      id: jsonResponse["id"] as int,
      florAreaList: List.generate((jsonResponse["areas"] as List<dynamic>).length, (index) => FlorAreaModel.fromJson((jsonResponse["areas"] as List<dynamic>)[index])),
      florRoundTableList: List.generate((jsonResponse["roundTable"] as List<dynamic>).length, (index) => FlorRoundTableModel.fromJson((jsonResponse["roundTable"] as List<dynamic>)[index])),
      florSquerTableList: List.generate((jsonResponse["squerTable"] as List<dynamic>).length, (index) => FlorSquerTableModel.fromJson((jsonResponse["squerTable"] as List<dynamic>)[index])),
      name: jsonResponse["name"] as String,
      size_x: jsonResponse["id"] as double,
      size_y: jsonResponse["id"] as double,
    );
  }
}

// x and y max = 1, min = 0
class FlorAreaModel{
  Color color;
  double x1;
  double x2;
  double y1;
  double y2;
  String name;

  FlorAreaModel({
    required this.color,
    required this.x1,
    required this.x2,
    required this.y1,
    required this.y2,
    required this.name,
  });

  factory FlorAreaModel.fromJson(response) {
    var jsonResponse = response as Map<String, dynamic>;
    return FlorAreaModel(
      color: jsonResponse["color"] as Color,
      x1: jsonResponse["x1"] as double,
      x2: jsonResponse["x2"] as double,
      y1: jsonResponse["y1"] as double,
      y2: jsonResponse["y2"] as double,
      name: jsonResponse["name"] as String,
    );
  }
}

class FlorRoundTableModel{
  Color color;
  double x;
  double y;
  String? img;
  double diameter;
  int tableID;

  FlorRoundTableModel({
    required this.color,
    required this.x,
    required this.y,
    required this.img,
    required this.diameter,
    required this.tableID,
  });

  factory FlorRoundTableModel.fromJson(response) {
    var jsonResponse = response as Map<String, dynamic>;
    return FlorRoundTableModel(
      color: jsonResponse["color"] as Color,
      x: jsonResponse["x"] as double,
      y: jsonResponse["y"] as double,
      diameter: jsonResponse["diameter"] as double,
      img: jsonResponse["img"] as String,
      tableID: jsonResponse["table"] as int,
    );
  }

}

class FlorSquerTableModel{
  Color color;
  double x1;
  double x2;
  double y1;
  double y2;
  int tableID;
  String? img;

  FlorSquerTableModel({
    required this.color,
    required this.x1,
    required this.x2,
    required this.y1,
    required this.y2,
    required this.img,
    required this.tableID,
  });

  factory FlorSquerTableModel.fromJson(response) {
    var jsonResponse = response as Map<String, dynamic>;
    return FlorSquerTableModel(
      color: jsonResponse["color"] as Color,
      x1: jsonResponse["x1"] as double,
      x2: jsonResponse["x2"] as double,
      y1: jsonResponse["y1"] as double,
      y2: jsonResponse["y2"] as double,
      img: jsonResponse["img"] as String,
      tableID: jsonResponse["table"] as int,
    );
  }
}