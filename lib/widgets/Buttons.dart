import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final color;
  final textColor;
  final String buttonText;
  final buttonTapped;
  final borderRadius;

  const MyButton(
      {this.color,
        this.textColor,
        required this.buttonText,
        this.buttonTapped,
        this.borderRadius,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonTapped,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Container(
            color: color ,
            child: Center(
                child: Text(buttonText,
                    style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))),
          ),
        ),
      ),
    );
  }
}
