


import 'package:flutter/material.dart';
import '../components/NotificationService.dart';
import '../screens/TablesViewScreen.dart';

class NotificationServiceProvider with ChangeNotifier {
  NotificationService? notificationService;
  bool isInizialized = false;

  void setNotificationService(context){
    if(isInizialized) return;
    isInizialized = true;
    notificationService = NotificationService();
    listenToNotificationStream(context: context);
    notificationService!.initializePlatformNotifications();
  }

  void listenToNotificationStream({context}) =>
      notificationService?.behaviorSubject.listen((payload) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TablesView(payload: payload)));
      });

}