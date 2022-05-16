import 'package:flutter/material.dart';

class InvoiceRestaurantInfo extends StatelessWidget {
  final String address;
  final String plz;
  final String stadt;
  final String phone;
  final String img;
  const InvoiceRestaurantInfo(
      {required this.address,
      required this.plz,
      required this.stadt,
      required this.phone,
      required this.img});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            img != '' ? Image.network(img, scale: 1.0) : const Text(''),
            Text(address,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2C3333),
                  fontSize: 20,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(plz,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3333),
                      fontSize: 20,
                    )),
                Text(' $stadt',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3333),
                      fontSize: 20,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Telefon:',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3333),
                      fontSize: 20,
                    )),
                Text(' $phone',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3333),
                      fontSize: 20,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
