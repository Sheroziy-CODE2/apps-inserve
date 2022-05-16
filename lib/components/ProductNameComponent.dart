import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../Providers/Products.dart';

class ProductNameComponent extends StatelessWidget {
  final int id;
  const ProductNameComponent({required this.id});

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context, listen: false);
    final product = productData.findById(id);

    return Text(
      '${product.name}',
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Color(0xFF2C3333),
        fontSize: 25,
      ),
    );
  }
}
