import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../Providers/Products.dart';

class ProductNameComponent extends StatelessWidget {
  final String name;
  const ProductNameComponent({required this.name});

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context, listen: false);

    return Text(
      '${name}',
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Color(0xFF2C3333),
        fontSize: 20,
      ),
    );
  }
}
