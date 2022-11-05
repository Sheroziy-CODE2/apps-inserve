


import 'dart:io';

import 'package:flutter/material.dart';

class ConnectionToInspery{

  Future<bool> check() async{
    try {
      final result = await InternetAddress.lookup('dev.inspery.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (e) {
      print('Can not connect to dev.inspery.com, error: ' + e.toString());
      return false;
    }
    return false;
  }

  Widget stateWidget(){
    return StatefulBuilder(
        builder: (context2, setState) {
          return SizedBox(
            height: 40,
            width: 220,
            child: Center(
              child: GestureDetector(
                onTap: (){
                  setState((){});
                },
                child:
                FutureBuilder<bool>(
                  future: check(), // async work
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting: return const Text('Verbindung wird überprüft...');
                      default:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return snapshot.data! ?
                          Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Expanded(flex: 5, child: Text("Verbindung erfolgreich")),
                                Expanded(flex: 1, child: Icon(Icons.check, color: Colors.green,))
                              ]
                          )
                              : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Expanded(flex: 5, child: Text("Verbindung fehlgeschlagen")),
                                Expanded(flex: 1, child: Icon(Icons.mood_bad, color: Colors.red,))
                              ]
                          );
                        }
                    }
                  },
                ),
              ),
            ),
          );
        });
  }

}