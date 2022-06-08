import 'package:flutter/cupertino.dart';

class CenterText extends StatelessWidget {
  final String text;
  const CenterText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      '  $text',
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Color(0xFF2C3333),
        fontSize: 18,
      ),
    );
  }
}
