import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:inspery_pos/printer/Testprint.dart';
import 'package:path_provider/path_provider.dart';




class ConfigPrinter{

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  bool _connected = false;
  bool closeWidow = false;
  late String pathImage;
  late TestPrint testPrint;


  Future<bool> checkState({required context}) async{
    print("Printer state connected: " + _connected.toString());

    testPrint = TestPrint();




      // set up the buttons
      Widget testPrintButton = TextButton(
        child: const Text("Test Print"),
        onPressed:  () {
          testPrint.bill(pathImage: pathImage, context: context);
        },
      );

      // set up the buttons
      Widget okButton = TextButton(
        child: const Text("OK"),
        onPressed:  () {
          closeWidow = true;
          Navigator.pop(context);
        },
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              Future<void> initPlatformState() async {
                bool? isConnected = await bluetooth.isConnected;
                List<BluetoothDevice> devices = [];
                try {
                  devices = await bluetooth.getBondedDevices();
                } on PlatformException {
                  // TODO - Error
                }

                bluetooth.onStateChanged().listen((state) {
                  switch (state) {
                    case BlueThermalPrinter.CONNECTED:
                      //setState(() {
                        _connected = true;
                        //closeWidow = true;
                        //print("bluetooth device state: connected");
                      //});
                      break;
                    case BlueThermalPrinter.DISCONNECTED:
                      //setState(() {
                        _connected = false;
                        print("bluetooth device state: disconnected");
                      //});
                      break;
                    case BlueThermalPrinter.DISCONNECT_REQUESTED:
                      //setState(() {
                        _connected = false;
                        print("bluetooth device state: disconnect requested");
                      //});
                      break;
                    case BlueThermalPrinter.STATE_TURNING_OFF:
                      //setState(() {
                        _connected = false;
                        print("bluetooth device state: bluetooth turning off");
                      //});
                      break;
                    case BlueThermalPrinter.STATE_OFF:
                      //setState(() {
                        _connected = false;
                        print("bluetooth device state: bluetooth off");
                      //});
                      break;
                    case BlueThermalPrinter.STATE_ON:
                      //setState(() {
                        _connected = false;
                        //print("bluetooth device state: bluetooth on");
                      //});
                      break;
                    case BlueThermalPrinter.STATE_TURNING_ON:
                      //setState(() {
                        _connected = false;
                        print("bluetooth device state: bluetooth turning on");
                      //});
                      break;
                    case BlueThermalPrinter.ERROR:
                      //setState(() {
                        _connected = false;
                        print("bluetooth device state: error");
                      //});
                      break;
                    default:
                      print(state);
                      break;
                  }
                });


                // setState(() {
                   _devices = devices;
                 //});

                if (isConnected??true) {
                 // setState(() {
                  print("Printer is allready connected");
                    _connected = true;
                    closeWidow = true;
                  //});
                }
              }
              Future show(
                  String message, {
                    Duration duration: const Duration(seconds: 3),
                  }) async {
                await Future.delayed(const Duration(milliseconds: 100));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    duration: duration,
                  ),
                );
              }
              List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
                List<DropdownMenuItem<BluetoothDevice>> items = [];
                if (_devices.isEmpty) {
                  items.add(const DropdownMenuItem(
                    child: Text('NONE'),
                  ));
                } else {
                  _devices.forEach((device) {
                    items.add(DropdownMenuItem(
                      child: Text(device.name!),
                      value: device,
                    ));
                  });
                }
                return items;
              }
              void _connect() {
                if (_device == null) {
                  show('No device selected.');
                } else {
                  bluetooth.isConnected.then((isConnected) {
                    if (!(isConnected?? false)) {
                      bluetooth.connect(_device!).catchError((error) {
                        setState(() =>
                        _connected = false
                        );
                      });
                      setState(() => _connected = true);
                    }
                  });
                }
              }
              void _disconnect() {
                bluetooth.disconnect();
                setState(() => _connected = false);
              }
              //write to app path
              Future<void> writeToFile(ByteData data, String path) {
                final buffer = data.buffer;
                return File(path).writeAsBytes(
                    buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
              }
              initSavetoPath() async {
                //read and write
                //image max 300px X 300px
                final filename = 'yourlogo.png';
                var bytes = await rootBundle.load("assets/images/yourlogo.png");
                String dir = (await getApplicationDocumentsDirectory()).path;
                writeToFile(bytes, '$dir/$filename');
                setState(() {
                  pathImage = '$dir/$filename';
                });
              }
              initPlatformState();
              initSavetoPath();
              testPrint = TestPrint();



              //---------------------------------------------------------------


              return AlertDialog(
                title: const Text("Drucker Konfigutieren"),
                content:

                SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Scaffold(
                    body:
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Device:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: DropdownButton(
                                items: _getDeviceItems(),
                                onChanged: (value) =>
                                    setState(() =>
                                    _device = value as BluetoothDevice),
                                value: _device,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.brown),
                              onPressed: () {
                                initPlatformState();
                              },
                              child: const Text(
                                'Refresh',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: _connected ? Colors.red : Colors
                                      .green),
                              onPressed: _connected ? _disconnect : _connect,
                              child: Text(
                                _connected ? 'Disconnect' : 'Connect',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  testPrintButton,
                  okButton,
                ],
              );
              print("299");
            }

            );
        },
      );


      print("Lets wait");
      while (!closeWidow) {
        await Future.delayed(const Duration(seconds: 1), () {
          return print("Wait for connection to printer...");
        });
      }
    Navigator.of(context).pop(true);
      return _connected;
    }
}
