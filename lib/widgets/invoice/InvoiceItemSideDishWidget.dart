import 'package:flutter/material.dart';
import 'package:inspery_pos/Providers/Products.dart';
import 'package:provider/provider.dart';

import '../reusable/CenterText.dart';

class InvoiceItemSideDishWidget extends StatelessWidget {
  // this widget is used to show a line of information about a side dish in the invoice
  final int id;
  const InvoiceItemSideDishWidget({required this.id});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context, listen: false).findById(id).product_price.firstWhere((element) => element.isSD);
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
                const Expanded(
                  flex: 1,
                  child: Text(
                    'X',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3333),
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: CenterText(text: product.description),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    '  ${product.price} Euro',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3333),
                      fontSize: 20,
                    ),
                  ),
                ),
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
