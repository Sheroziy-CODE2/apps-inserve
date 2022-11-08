import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../Models/WorkerModel.dart';
import '../util/EnvironmentVariables.dart';





class WorkersProvider with ChangeNotifier {
  //Collect all information of workers in the _items
  final List<WorkerModel> _items = [];

  List<WorkerModel> get items {
    return [..._items];
  }


  Future<void> addWorkers({required token, required context}) async {

    final url = Uri.parse(
      EnvironmentVariables.apiUrl+'authy/workers',
    );
    final headers = {"Authorization": "Token $token"};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      for (int i = 0; i < data.length; i++) {
        var pro = WorkerModel.fromJson(data[i], context: context);
        _items.add(pro);
        //print("Product Name: " + pro.name + "  ID: " + pro.id.toString());
      }
    } else {
      print('Products: Request failed with status: ${response.statusCode}.');
    }
    notifyListeners();
  }


  //Find workers by ID or Name
  WorkerModel findById(int id) {

    return _items.firstWhere((t) => t.id == id,
        orElse: () => WorkerModel(
            id: 0, username: '0', profile: '0'));
  }

  WorkerModel findByName(String username) {

    return _items.firstWhere((t) => t.username == username,
        orElse: () => WorkerModel(
            id: 0, username: '0', profile: '0'));
  }

}