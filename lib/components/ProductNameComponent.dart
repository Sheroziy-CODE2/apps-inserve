import 'package:flutter/cupertino.dart';

class ProductNameComponent extends StatelessWidget {
  final String name;
  const ProductNameComponent({required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${name}',
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Color(0xFF2C3333),
        fontSize: 20,

      ),
    );
  }
}
