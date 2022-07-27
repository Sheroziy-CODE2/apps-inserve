import 'package:flutter/material.dart';
import '/Providers/Products.dart';
import 'package:provider/provider.dart';
import '../reusable/CenterText.dart';

class InvoiceItemSideDishWidget extends StatelessWidget {
  // this widget is used to show a line of information about a side dish in the invoice
  final String name;
  const InvoiceItemSideDishWidget({required this.name});

  @override
  Widget build(BuildContext context) {
    final product =
        Provider.of<Products>(context, listen: false).findByName(name);
    var productName =
        product.name.length > 10 ? product.name.substring(0, 10) : product.name;
    var price = 0.0;
    for (var i = 0; i < product.product_price.length; i++) {
      if (product.product_price[i].description == "SD") {
        price = product.product_price[i].price;
      }
    }
    // .product_price
    // .firstWhere((element) => element.isSD);
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
                  child: CenterText(text: productName),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    '  ${price} Euro',
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
