import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../reusable/CenterText.dart';
import '../../Providers/Ingredients.dart';

class InvoiceItemIngredientsWidget extends StatelessWidget {
  // this widget is used to show a line of information about an added ot deleted ingredient from an invoice
  final int id;
  final String operator;
  const InvoiceItemIngredientsWidget(
      {required this.id, required this.operator});

  @override
  Widget build(BuildContext context) {
    final ingredientsProvider =
        Provider.of<Ingredients>(context, listen: false);
    final ingredient = ingredientsProvider.findById(id);

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
                  flex: 4,
                  child: CenterText(text: ingredient.name.toString()),
                ),
                operator == '+'
                    ? Expanded(
                        flex: 4,
                        child: Text(
                          '  ${ingredient.price} Euro',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2C3333),
                            fontSize: 20,
                          ),
                        ),
                      )
                    : Container(),
                const Expanded(
                  flex: 2,
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
