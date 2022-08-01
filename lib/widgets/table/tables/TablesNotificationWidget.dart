import 'package:flutter/material.dart';

class TablesNotificationWidget extends StatefulWidget {
  const TablesNotificationWidget({Key? key}) : super(key: key);

  @override
  State<TablesNotificationWidget> createState() => _TablesNotificationWidgetState();
}

class _TablesNotificationWidgetState extends State<TablesNotificationWidget> {


  List<IconData> icons = [
    Icons.plus_one,
    Icons.message_outlined,
    Icons.account_balance_wallet_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    int index = -1;
    return SizedBox(
      width: 50,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children:
        icons.map((e) {
          index++;
          return Positioned(
            left: index * 17 + 5,
            child: Container(
              width: 40,
              height: 40,
              child: Icon(e),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .primaryColorDark
                        .withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset:
                    const Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                color: Theme.of(context).cardColor,//Theme.of(context).primaryColorDark,

                // color: Colors.white,
                // boxShadow: [
                //   const BoxShadow(color: Colors.green, spreadRadius: 3),
                // ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
