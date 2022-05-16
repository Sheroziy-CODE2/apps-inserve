import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../Providers/Prices.dart';

class PriceComponent extends StatelessWidget {
  final int id;
  const PriceComponent({required this.id});

  @override
  Widget build(BuildContext context) {
    final pricetData = Provider.of<Prices>(context, listen: false);
    final price = pricetData.findById(id);

    return Text(
      ' ${price.price}',
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Color(0xFF2C3333),
        fontSize: 25,
      ),
    );
  }
}
