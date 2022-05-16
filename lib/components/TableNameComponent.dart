import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/Tables.dart';

class TableNameComponent extends StatelessWidget {
  final int id;
  const TableNameComponent({required this.id});

  @override
  Widget build(BuildContext context) {
    final TablesProvider = Provider.of<Tables>(context, listen: false);
    final table = TablesProvider.findById(id);
    return Container(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        '${table.name}',
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xFF2C3333),
          fontSize: 22,
        ),
      ),
    );
    ;
  }
}
