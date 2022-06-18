import 'package:flutter/material.dart';
import 'package:inspery_waiter/Providers/DipsProvider.dart';
import 'package:provider/provider.dart';

import '../reusable/CenterText.dart';

class InvoiceItemDipWidget extends StatelessWidget {
  // this widget is used to show a line of information about a dip in the invoice
  final int id;
  const InvoiceItemDipWidget({required this.id});

  @override
  Widget build(BuildContext context) {
    final dip = Provider.of<DipsProvider>(context, listen: false).findById(id);
    var name = dip.name.length > 10 ? dip.name.substring(0, 10) : dip.name;
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
                  child: CenterText(text: name),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    '  ${dip.price} Euro',
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
