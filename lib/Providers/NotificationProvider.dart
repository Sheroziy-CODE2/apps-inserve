import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Models/NotificationModel.dart';


class NotificationProvider with ChangeNotifier {
  List<NotificationModel> notificationTypes = [];
  ScrollController scrollController = ScrollController();


  Future<void> addNotificationType({required token, required context}) async {
    // this function will add ingredients to the _items List
    final url = Uri.parse(
      'https://www.inspery.com/table/notification_types',
    );
    final headers = {
      "Content-type": "application/json",
      "Authorization": "Token ${token}"
    };
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(response.bodyBytes)));
      for (int i = 0; i < data.length; i++) {
        var ing = NotificationModel.fromJson(data[i], context: context);
        notificationTypes.add(ing);
      }
    } else {
      print(
          'Request failed with status: ${response.statusCode}. menu/ingriedients/');
    }
    notifyListeners();
  }

}

