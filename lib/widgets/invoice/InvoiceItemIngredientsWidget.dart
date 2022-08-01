import 'package:flutter/material.dart';
import '../reusable/CenterText.dart';

class InvoiceItemIngredientsWidget extends StatelessWidget {
  // this widget is used to show a line of information about an added ot deleted ingredient from an invoice
  final String name;
  final String operator;
  const InvoiceItemIngredientsWidget(
      {required this.name, required this.operator});

  @override
  Widget build(BuildContext context) {

    return Material(
      type: MaterialType.transparency,
      child: Container(
          padding: const EdgeInsets.only(left: 7.5, right: 7.5),
          child: Column(
            children: [
              Row(children: [
                const Expanded(
                  flex: 1,
                  child: CenterText(text: ''),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    operator,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3333),
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    name,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3333),
                      fontSize: 16,
                    ),
                  ),
                ),

                const Expanded(
                  flex: 6,
                  child: Text(
                    ' ',
                  ),
                ),
              ]),
            ],
          )),
    );
  }
}
