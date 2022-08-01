
import 'package:flutter/material.dart';
import '../../Models/InvoiceItem.dart';
import '../reusable/CenterText.dart';
import '../../components/ProductNameComponent.dart';
import '../invoice/InvoiceItemSideDishWidget.dart';
import '../invoice/InvoiceItemIngredientsWidget.dart';

class InvoiceOrderWidget extends StatelessWidget {
  final InvoiceItem invoiceItem;
  const InvoiceOrderWidget({required this.invoiceItem});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
          padding: const EdgeInsets.only(left: 7.5, right: 7.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                    flex: 1,
                    child: CenterText(text: invoiceItem.quantity.toString())),
                const Expanded(
                  flex: 1,
                  child: Text(
                    ' x ',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3333),
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: ProductNameComponent(name: invoiceItem.product),
                ),
                Expanded(
                  flex: 3,
                  child: //PriceComponent(id: invoiceItem.price),
                      Text(
                    invoiceItem.price.toString(),
                        textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3333),
                      fontSize: 18,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '  ${invoiceItem.amount}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3333),
                      fontSize: 20,
                    ),
                  ),
                ),
              ]),
              invoiceItem.side_products.isNotEmpty
                  ? Column(children: [
                      SizedBox(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: invoiceItem.side_products.length,
                          itemBuilder: (context, index) =>
                              InvoiceItemSideDishWidget(
                                  name: invoiceItem.side_products[index]),
                        ),
                      ),
                    ])
                  : Container(),
              invoiceItem.added_ingredients.isNotEmpty
                  ? Column(children: [
                      SizedBox(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: invoiceItem.added_ingredients.length,
                          itemBuilder: (context, index) =>
                              InvoiceItemIngredientsWidget(
                                  name: invoiceItem.added_ingredients[index],
                                  operator: '+'),
                        ),
                      ),
                    ])
                  : Container(),
              invoiceItem.deleted_ingredients.isNotEmpty
                  ? Column(children: [
                      SizedBox(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: invoiceItem.deleted_ingredients.length,
                          itemBuilder: (context, index) =>
                              InvoiceItemIngredientsWidget(
                                  name: invoiceItem.side_products[index],
                                  operator: '-'),
                        ),
                      ),
                    ])
                  : Container(),
              Container(
                height: 10,
              ),
            ],
          )),
    );
  }
}