import 'package:flutter/material.dart';

//The class help to create the buttons with image and the text below, plus allow to show what is selected
class MyImageButton extends StatefulWidget {
  final selectedIconColor;
  var buttonTapped;
  String? image;
  final borderRadius;
  final unselectedIconColor;
  final username;
  final chosenButton;

  MyImageButton(
      {this.selectedIconColor,
        this.buttonTapped,
        this.image,
        this.borderRadius,
        this.unselectedIconColor,
        this.username,
        this.chosenButton});
  @override
  _MyImageButtonState createState() => _MyImageButtonState();
}

class _MyImageButtonState extends State<MyImageButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.buttonTapped,
      child: Column(
        children: [
          Container (
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(2.0),
            child: Container(
              decoration: BoxDecoration(
                color: (widget.chosenButton == widget.username) ? widget.selectedIconColor : widget.unselectedIconColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: widget.borderRadius,
                  child: widget.image == null ?
                  Image.asset("assets/images/logo_icon.png") :
                  Image.network(
                    "https://www.inspery.com"+widget.image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: (widget.chosenButton == widget.username) ? widget.selectedIconColor : widget.unselectedIconColor,
              borderRadius: widget.borderRadius,
            ),
            child : Container (
              padding: const EdgeInsets.all(5),
              child: Text(
                "  "+widget.username+"  ",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: (widget.chosenButton == widget.username) ? Theme.of(context).cardColor : Theme.of(context).primaryColorDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}