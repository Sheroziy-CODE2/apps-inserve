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
                  child: ProductNameComponent(id: invoiceItem.product),
                ),
                const Expanded(
                  flex: 2,
                  child: //PriceComponent(id: invoiceItem.price),
                  Text(
                   "??",
                   style: TextStyle(
                     fontWeight: FontWeight.w500,
                     color: Color(0xFF2C3333),
                     fontSize: 25,
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
                      fontSize: 20,
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
                      fontSize: 25,
                    ),
                  ),
                ),
              ]),
              invoiceItem.sideDish.length > 0
                  ? Column(children: [
                      SizedBox(
                        height: invoiceItem.sideDish.length * 24,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: invoiceItem.sideDish.length,
                          itemBuilder: (context, index) =>
                              InvoiceItemSideDishWidget(
                                  id: invoiceItem.sideDish[index]),
                        ),
                      ),
                    ])
                  : Container(),
              invoiceItem.added_ingredients.length > 0
                  ? Column(children: [
                      SizedBox(
                        height: invoiceItem.added_ingredients.length * 24,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: invoiceItem.sideDish.length,
                          itemBuilder: (context, index) =>
                              InvoiceItemIngredientsWidget(
                                  id: invoiceItem.sideDish[index],
                                  operator: '+'),
                        ),
                      ),
                    ])
                  : Container(),
              invoiceItem.deleted_ingredients.length > 0
                  ? Column(children: [
                      SizedBox(
                        height: invoiceItem.deleted_ingredients.length * 24,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: invoiceItem.sideDish.length,
                          itemBuilder: (context, index) =>
                              InvoiceItemIngredientsWidget(
                                  id: invoiceItem.sideDish[index],
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
