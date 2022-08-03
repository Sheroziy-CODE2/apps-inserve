import 'package:flutter/material.dart';

class QRImageAlert{

  // set up the AlertDialog
  show({required image, required context}) {
    var alert = AlertDialog(
      title: const Text("Image to print"),
      content: Image.memory(image),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  }