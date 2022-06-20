import 'package:flutter/material.dart';

class InvoicetaxInfo extends StatelessWidget {
  const InvoicetaxInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        type: MaterialType.transparency,
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      'Steuer',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2C3333),
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'A=',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2C3333),
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'B=',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2C3333),
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Steuer',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2C3333),
                        fontSize: 20,
                      ),
                    ),
                  ],
                )),
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      '%',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2C3333),
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '16%',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2C3333),
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '5%',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2C3333),
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '%',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2C3333),
                        fontSize: 20,
                      ),
                    ),
                  ],
                )),
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      'Netto',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2C3333),
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '4,37€',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2C3333),
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '12,37€',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2C3333),
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '15,37€',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2C3333),
                        fontSize: 20,
                      ),
                    ),
                  ],
                )),
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      'Brutto',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2C3333),
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '4,37€',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2C3333),
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '12,37€',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2C3333),
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '15,37€',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2C3333),
                        fontSize: 20,
                      ),
                    ),
                  ],
                )),
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      'Steuer',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2C3333),
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '0,37€',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2C3333),
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '1,37€',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2C3333),
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '2,37€',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2C3333),
                        fontSize: 20,
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
