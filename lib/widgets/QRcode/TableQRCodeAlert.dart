
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TableQRCodeAlert {

//ShowDialog to choose the table
  showTableChangeDialog({required BuildContext context, required String tableKey,  required String restaurantImageSVG}) {

    Widget qrCornerSymbol = Container(
          height: 56,
          width: 56,
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(20),
                border: Border.all(
                    color: Colors.black,
                    width: 7)
            ),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                    borderRadius:
                    BorderRadius.circular(8),
                ),
                height: 26,
                width: 26,
              ),
            ),
          ),
    );


    StatefulBuilder builder = StatefulBuilder(
      builder: (BuildContext contextXX, setState) {
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container
                  (
                  decoration: BoxDecoration(
                    color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(5),
                      border: Border.all(
                          color: Colors.black,
                          width: 1)),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10, right: 10, left: 10),
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 250,
                            height: 250,
                            child: Stack(
                              children: [
                                Positioned(
                                  child: QrImage(
                                    data: "inspery.com/table/" +tableKey,
                                    version: QrVersions.auto,
                                    gapless: false,
                                    size: 250,
                                    eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Colors.black),
                                    errorCorrectionLevel: 3,
                                    embeddedImage: const AssetImage('assets/images/inspery_custom_logo.png'),
                                    embeddedImageStyle: QrEmbeddedImageStyle(
                                      size: const Size(120, 120),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 8,
                                  top: 8,
                                    child: qrCornerSymbol,
                                ),
                                Positioned(
                                  right: 15,
                                  top: 8,
                                  child: qrCornerSymbol,
                                ),
                                Positioned(
                                  left: 8,
                                  bottom: 8,
                                  child: qrCornerSymbol,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Column(
                            children: [
                              const Spacer(),
                              const Text("Scan mich!", textAlign: TextAlign.right, style: TextStyle(fontSize: 14),),
                              const Text("Karte & Zahlen", textAlign: TextAlign.right, style: TextStyle(fontSize: 24),),
                              const Spacer(),
                              Container(
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  child:
                                  Center(
                                    child: Column(
                                      children: [
                                        const Text("Tisch-Key", textAlign: TextAlign.right, style: TextStyle(fontSize: 14),),
                                        Text(tableKey, textAlign: TextAlign.center, style: const TextStyle(fontSize: 23),),
                                      ],
                                    ),
                                  )
                              ),
                              const Spacer(),
                              const Text("powered by", textAlign: TextAlign.right, style: TextStyle(fontSize: 14),),
                              SizedBox(
                                height: 30,
                                child: SvgPicture.asset(
                                  'assets/illustrations/inspery.svg',
                                  color: Colors.black,
                                  matchTextDirection: true,
                                ),
                              ),
                              const Spacer(),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    SizedBox(
                      height: 40,
                      width: 120,
                      child: GestureDetector(
                        onTap: () {

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
                                    color:
                                    const Color(0xFFF3F3F3),
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

