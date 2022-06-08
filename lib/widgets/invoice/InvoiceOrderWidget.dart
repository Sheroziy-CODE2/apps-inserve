import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Models/InvoiceItem.dart';
import '../reusable/CenterText.dart';
import '../../components/ProductNameComponent.dart';

import '../invoice/InvoiceItemSideDishWidget.dart';
import '../invoice/InvoiceItemIngredientsWidget.dart';
import '../invoice/InvoiceItemDipWidget.dart';

class InvoiceOrderWidget extends StatelessWidget {
  final InvoiceItem invoiceItem;
  const InvoiceOrderWidget({required this.invoiceItem});

  @override
  Widget build(BuildContext context) {
    var name = invoiceItem.product.length > 10
        ? invoiceItem.product.substring(0, 10)
        : invoiceItem.product;
    return Material(
      type: MaterialType.transparency,
      child: Container(
          padding: EdgeInsets.only(left: 7.5, right: 7.5),
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
                    ' X ',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3333),
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: ProductNameComponent(name: name),
                ),
                Expanded(
                  flex: 2,
                  child: //PriceComponent(id: invoiceItem.price),
                      Text(
                    invoiceItem.price.toString(),
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
                    'Euro',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3333),
                      fontSize: 18,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '  ${invoiceItem.amount}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3333),
                      fontSize: 22,
                    ),
                  ),
                ),
              ]),
              invoiceItem.side_products.length > 0
                  ? Column(children: [
                      SizedBox(
                        height: invoiceItem.side_products.length * 28,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: invoiceItem.side_products.length,
                          itemBuilder: (context, index) =>
                              InvoiceItemSideDishWidget(
                                  name: invoiceItem.side_products[index]),
                        ),
                      ),
                    ])
                  : Container(),
              invoiceItem.dips.length > 0
                  ? Column(children: [
                      SizedBox(
                        height: invoiceItem.dips.length * 28,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: invoiceItem.dips.length,
                          itemBuilder: (context, index) =>
                              InvoiceItemDipWidget(id: invoiceItem.dips[index]),
                        ),
                      ),
                    ])
                  : Container(),
              invoiceItem.added_ingredients.length > 0
                  ? Column(children: [
                      SizedBox(
                        height: invoiceItem.added_ingredients.length * 28,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: invoiceItem.added_ingredients.length,
                          itemBuilder: (context, index) =>
                              InvoiceItemIngredientsWidget(
                                  id: invoiceItem.added_ingredients[index],
                                  operator: '+'),
                        ),
                      ),
                    ])
                  : Container(),
              invoiceItem.deleted_ingredients.length > 0
                  ? Column(children: [
                      SizedBox(
                        height: invoiceItem.deleted_ingredients.length * 28,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: invoiceItem.deleted_ingredients.length,
                          itemBuilder: (context, index) =>
                              InvoiceItemIngredientsWidget(
                                  id: invoiceItem.side_products[index],
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
