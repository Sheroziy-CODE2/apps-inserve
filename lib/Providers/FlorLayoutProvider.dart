

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:inspery_waiter/Models/FlorLayoutModel.dart';

class FlorLayoutProvider with ChangeNotifier {
  List<FlorLayoutModel> _items = [];

  List<FlorLayoutModel> get items {
    return [..._items];
  }

  double highestX(){
    double value = 0;
    _items.forEach((element) {
      if(value < element.size_x) value = element.size_x;
    });
    return value;
  }

  double highestY(){
    double value = 0;
    _items.forEach((element) {
      if(value < element.size_y) value = element.size_y;
    });
    return value;
  }

  Future<void> generateFlors({required numberOfFlors, required context}) async {
    _items = [];
    for(int x = 0; x < numberOfFlors; x++){
      FlorLayoutModel florLayoutModel =
        FlorLayoutModel(
            color: const Color.fromARGB(150, 100, 100, 100),
            id: x,
            florAreaList: [FlorAreaModel(color: Color.fromARGB(255, Random().nextInt(255), Random().nextInt(255), Random().nextInt(255)), x1: 0.1, x2: 0.3, y1: 0.3, y2: 0.7, name: "Außenbereich"),
                FlorAreaModel(color: Color.fromARGB(255, Random().nextInt(255), Random().nextInt(255), Random().nextInt(255)), x1: 0.1, x2: 0.9, y1: 0.7, y2: 0.9, name: "Außenbereich"),
                FlorAreaModel(color: Color.fromARGB(255, Random().nextInt(255), Random().nextInt(255), Random().nextInt(255)), x1: 0.3, x2: 0.9, y1: 0.1, y2: 0.7, name: "Innenbereich"),
                FlorAreaModel(color: Color.fromARGB(255, Random().nextInt(255), Random().nextInt(255), Random().nextInt(255)), x1: 0.5, x2: 0.9, y1: 0.1, y2: 0.3, name: "Küche")],
            florRoundTableList: [
              FlorRoundTableModel(color: Colors.black54, x: 0.2, y: 0.4, img: null, diameter: 0.1, tableID: 183),
              FlorRoundTableModel(color: Colors.black54, x: 0.2, y: 0.6, img: null, diameter: 0.1, tableID: 180),
              FlorRoundTableModel(color: Colors.black54, x: 0.2, y: 0.8, img: null, diameter: 0.1, tableID: 186),
              FlorRoundTableModel(color: Colors.black54, x: 0.4, y: 0.8, img: null, diameter: 0.1, tableID: 188),
              FlorRoundTableModel(color: Colors.black54, x: 0.6, y: 0.8, img: null, diameter: 0.1, tableID: 189),
            ],
            florSquerTableList: [
            FlorSquerTableModel(color: Colors.black54, x1: 0.4, x2: 0.8, y1: 0.4, y2: 0.6, tableID: 178, img: null,)
          ],
            name: "Stockwerk " + x.toString(), size_y: 200,  size_x: 200,
        );
      _items.add(florLayoutModel);
    }

    //notifyListeners();
  }


  FlorLayoutModel findById(int id) {
    return _items.firstWhere((t) => t.id == id,
        orElse: () => FlorLayoutModel(
        color: Colors.white12,
        id: 0, florAreaList: [],
        florRoundTableList: [],
        florSquerTableList: [],
        name: "not Found",
          size_x: 200,
          size_y: 200,
    ));
  }
}
