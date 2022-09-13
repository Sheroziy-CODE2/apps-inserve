import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/Tables.dart';

class TableScreenTopButtonWidget extends StatefulWidget {
  const TableScreenTopButtonWidget({Key? key, required this.onTouch, required this.name, required this.color}) : super(key: key);
  final Function onTouch;
  final String name;
  final Color color;

  @override
  State<TableScreenTopButtonWidget> createState() => _TableScreenTopButtonWidgetState();
}

class _TableScreenTopButtonWidgetState extends State<TableScreenTopButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final tablesData = Provider.of<Tables>(context, listen: true);
    return  GestureDetector(
      onTapUp: (e){
        widget.onTouch(e);
        },
      child: Container(
        height: 35,
        margin: const EdgeInsets.only(left: 5,right: 5),
        padding: const EdgeInsets.only(left: 5,right: 5),
        decoration: BoxDecoration(
          color: (widget.name == "Bar" ? tablesData.notificationFromBar : tablesData.notificationFromKitch) ?
          widget.color : const Color(0xFFE3E3E3),
          borderRadius: const BorderRadius.all(Radius.circular(15.0) //
          ),
        ),
        child:
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Spacer(),
            Center(child: Text(widget.name, style: const TextStyle(fontSize: 25),)),
            const Spacer(),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF474747),
                borderRadius: BorderRadius.all(Radius.circular(15.0) //
                ),
              ),
              child: Icon(Icons.notifications_none, color: (widget.name == "Bar" ? tablesData.notificationFromBar : tablesData.notificationFromKitch)  ?
              widget.color : const Color(0xFFE3E3E3)),
            )
          ],
        ),
      ),
    );
  }
}
