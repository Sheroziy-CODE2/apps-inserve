import 'package:flutter/material.dart';
import '/widgets/table/TableOverviewProductItem.dart';
import 'package:provider/provider.dart';

import '../../Providers/TableItemsProvidor.dart';
import '../../Providers/Tables.dart';

class TableOverviewProductList extends StatefulWidget {
  const TableOverviewProductList({required this.id, Key? key})
      : super(key: key);
  final int id;

  @override
  _TableOverviewProductListState createState() =>
      _TableOverviewProductListState();
}

class _TableOverviewProductListState extends State<TableOverviewProductList> {
  int lastLength = 0;
  late final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    TableItemsProvidor tableItemsProvidor =
        Provider.of<Tables>(context, listen: true).findById(widget.id).tIP;
    if (lastLength < tableItemsProvidor.getLength()) {
      Future.delayed(const Duration(milliseconds: 200), () {
        //Because we have to wait until the TableOverviewProductChange Widget is loaded
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
    lastLength = tableItemsProvidor.getLength();
    final double width = MediaQuery.of(context).size.width;
    return Flexible(
      child: ListView.separated(
        controller: _scrollController,
        itemBuilder: (_, index) {
          return GestureDetector(
            onPanEnd: tableItemsProvidor.tableItems[index].isFromServer()
                ? null
                : (x) {
                    if (x.velocity.pixelsPerSecond.distance > 150) {
                      tableItemsProvidor.removeSingelProduct(
                          pos: index, context: context);
                    }
                  },
            child: TableOverviewProductItem(
              width: width,
              tableItemProvidor: tableItemsProvidor.tableItems[index],
              index: index,
            ),
          );
        },
        separatorBuilder: (_, x) => const Divider(
          color: Colors.black,
        ),
        itemCount: tableItemsProvidor.tableItems.length,
      ),
    );
  }
}
