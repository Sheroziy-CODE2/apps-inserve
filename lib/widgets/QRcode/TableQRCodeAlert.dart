

import 'dart:typed_data';


import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

import '../../printer/ConfigPrinter.dart';
import '../../util/EnvironmentVariables.dart';

class TableQRCodeAlert {

//ShowDialog to choose the table
  showTableChangeDialog({required BuildContext context, required int tableID, required String tableKey,  required String restaurantImageSVG}) {

    Widget qrCornerSymbol = Container(
      height: 20,
      width: 20,
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(7),
            border: Border.all(
                color: Colors.black,
                width: 4)
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius:
              BorderRadius.circular(4),
            ),
            height: 10,
            width: 10,
          ),
        ),
      ),
    );


    StatefulBuilder builder = StatefulBuilder(
      builder: (BuildContext contextXX, setState) {
        ScreenshotController screenshotController1 = ScreenshotController();
        ScreenshotController screenshotController2 = ScreenshotController();
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          title: const Text("Tisch QR Code",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width-50,
            child: Container(
              height: 490,
              width: 200,
              child: Column(
                children: [
                  const SizedBox(height: 120,),
                  Column(
                    children: [
                      Container(
                        color: Colors.greenAccent,
                        child: Transform.scale(
                          scale: 2,
                          child: Container(
                            width: 145,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(5),
                                border: Border.all(
                                    color: Colors.black,
                                    width: 1)),
                            alignment: Alignment.center,
                            child: Container(
                              child: FutureBuilder<String?>(
                                  future: EnvironmentVariables().getQRPath(tableID: tableID, tableKey: tableKey),
                                  builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                                    if(snapshot.data == null){
                                      return const Center(child: Text("load.."));
                                    }
                                    return Column(
                                    children: [
                                      const SizedBox(height: 6,),
                                      Screenshot(
                                        controller: screenshotController2,
                                        child: RotatedBox(
                                          quarterTurns: 3,
                                          child: Container(
                                            color: Colors.white,
                                            height: 145,
                                            child: Column(
                                              children: [
                                                const Spacer(),
                                                const Text("Scan mich!", textAlign: TextAlign.right, style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold),),
                                                const Text("Menu & Zahlen", textAlign: TextAlign.right, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),),
                                                const Spacer(),
                                                Container(
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey.withOpacity(0.1),
                                                      borderRadius: BorderRadius.circular(28),
                                                        border: Border.all(
                                                            color: Colors.black,
                                                            width: 1),
                                                    ),
                                                    child:
                                                    Center(
                                                      child: Column(
                                                        children: [
                                                          const Text("Tisch-Key", textAlign: TextAlign.right, style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold),),
                                                          Text(tableKey, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),),
                                                        ],
                                                      ),
                                                    )
                                                ),
                                                const Spacer(),
                                                const Text("powered by", textAlign: TextAlign.right, style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold),),
                                                const Text("I N S P E R Y", textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),),
                                                // SizedBox(
                                                //   width: 80,
                                                //   child: SvgPicture.asset(
                                                //     'assets/illustrations/inspery.svg',
                                                //     color: Colors.black,
                                                //     matchTextDirection: true,
                                                //   ),
                                                // ),
                                                const Spacer(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Screenshot(
                                        controller: screenshotController1,
                                        child: RotatedBox(
                                          quarterTurns: 3,
                                          child: Container(
                                            color: Colors.white,
                                            width: 115,
                                            height: 115,
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  child:
                                                      QrImage(
                                                        data: snapshot.data!,
                                                        version: QrVersions.auto,
                                                        gapless: false,
                                                        size: 145,
                                                        eyeStyle: const QrEyeStyle(
                                                            eyeShape: QrEyeShape
                                                                .square,
                                                            color: Colors.black),
                                                        errorCorrectionLevel: 3,
                                                        embeddedImage: const AssetImage(
                                                            'assets/images/inspery_custom_logo.png'),
                                                        embeddedImageStyle: QrEmbeddedImageStyle(
                                                          size: const Size(50, 50),
                                                        ),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 12,
                                                  top: 12,
                                                  child: qrCornerSymbol,
                                                ),
                                                Positioned(
                                                  right: 12,
                                                  top: 12,
                                                  child: qrCornerSymbol,
                                                ),
                                                Positioned(
                                                  left: 12,
                                                  bottom: 12,
                                                  child: qrCornerSymbol,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 125,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      SizedBox(
                        height: 40,
                        width: 120,
                        child: GestureDetector(
                          onTap: () {
                            print("Not supported jet");
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey,
                                    width: 1),
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(20),
                                    ),
                                    child: Icon(
                                      Icons.share,
                                      color: Colors.black
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                  const Spacer(),
                                  const Text("Share"),
                                  const Spacer(),
                                ],
                              )),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 40,
                        width: 120,
                        child: GestureDetector(
                          onTap: () async {

                            final ConfigPrinter _configPrinter =
                            ConfigPrinter();
                            print("connection " + (await _configPrinter.checkState()).toString());
                            BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
                            bluetooth.isConnected.then((isConnected) async {
                              if (isConnected ?? false) {
                                await bluetooth.printNewLine();
                                await screenshotController2.capture().then((Uint8List? image) async {
                                  await bluetooth.printImageBytes(image!);
                                  //QRImageAlert().show(image: image, context: context);
                                }).catchError((onError) {
                                  print(onError);
                                });
                                await screenshotController1.capture().then((Uint8List? image) async {
                                  await bluetooth.printImageBytes(image!);
                                  //QRImageAlert().show(image: image, context: context);
                                }).catchError((onError) {
                                  print(onError);
                                });
                                await bluetooth.printNewLine();
                                await bluetooth.printNewLine();
                                await bluetooth.printNewLine();
                              }
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey,
                                    width: 1),
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(20),
                                    ),
                                    child: Icon(
                                      Icons.print,
                                      color: Colors.black
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                  const Spacer(),
                                  const Text("Drucken"),
                                  const Spacer(),
                                ],
                              )),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
    // show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return builder;
        });
  }
}

