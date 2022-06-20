import 'package:flutter/material.dart';


//The class help to create the buttons with the text below, plus allow to show what is selected
class MySelectedButton extends StatelessWidget {
  final selectedColor;
  final unselectedColor;
  final buttonText;
  final buttonTapped;
  final borderRadius;
  var chosenButton;

  MySelectedButton({
    required this.selectedColor,
    required this.buttonText,
    required this.buttonTapped,
    required this.borderRadius,
    required this.chosenButton,
    required this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonTapped,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Container(
            color:
                (chosenButton.contains(buttonText)) ? selectedColor : unselectedColor,
            child: Center(
                child: Text(buttonText,
                    style: TextStyle(
                        color: (chosenButton.contains(buttonText))
                            ? Theme.of(context).cardColor
                            : Theme.of(context).primaryColorDark,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))),
          ),
        ),
      ),
    );
  }
}
