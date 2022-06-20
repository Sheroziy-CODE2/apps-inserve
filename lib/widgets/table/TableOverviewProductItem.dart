import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Providers/Products.dart';
import '../../Providers/TableItemChangeProvidor.dart';
import '../../Providers/TableItemProvidor.dart';

///Single Item of a TableOverviewList
class TableOverviewProductItem extends StatefulWidget {
  TableOverviewProductItem(
      {//required this.tablesItemID,
      required this.width,
      required this.tableItemProvidor,
        required this.index,
      Key? key})
      : super(key: key);
  final double width;
  final double _height = 55;
  final int index;
  //final int tablesItemID;
  final TableItemProvidor tableItemProvidor;

  final Map<bool, double> pos_percentage_field_amount_1 = {
    false: 0.03,
    true: 0.86
  };
  final Map<bool, double> pos_percentage_field_description_1 = {
    false: 0.14,
    true: 0.03
  };
  final Map<bool, double> pos_percentage_field_price_1 = {
    false: 0.72,
    true: 0.62
  };

  @override
  _TableOverviewProductItemState createState() =>
      _TableOverviewProductItemState();
}

class _TableOverviewProductItemState extends State<TableOverviewProductItem> {
  bool onSwipe = false;

  @override
  Widget build(BuildContext context) {
     var tableItemChangeProvidor = Provider.of<TableItemChangeProvidor>(context, listen: true);
     var productProvidor = Provider.of<Products>(context, listen: true);

    return GestureDetector(
      onTap: () async {
        tableItemChangeProvidor.showProduct(index: widget.index, context: context, toggle: true);
      },
      child: AnimatedContainer(
          decoration: BoxDecoration(
            border: Border.all(
                color: tableItemChangeProvidor.getActProduct() ==
                    widget.index
                    ? Colors.blue.withOpacity(0.7)
                    : Colors.transparent,
                width: 3),
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            color: widget.tableItemProvidor.fromWaiter ? const Color(0xFFD3E03A).withOpacity(0.8) : Colors.transparent,
          ),
          height: (widget.tableItemProvidor.paymode && widget.tableItemProvidor.fromWaiter)  ? 0 : widget._height + 2,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          child: Stack(
            children: [
              //That is the Price Field
              AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.fastOutSlowIn,
                left: (widget.width *
                    widget.pos_percentage_field_price_1[
                    widget.tableItemProvidor.getPaymode()]!),
                //     bottom: 10,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    if(onSwipe) return;
                    onSwipe = true;
                    if (widget.tableItemProvidor.getPaymode()) {
                      // Swiping in right direction.
                      if (details.delta.dx > 0) {
                        widget.tableItemProvidor.maxAmountInCard(context: context);
                      }
                      // Swiping in left direction.
                      if (details.delta.dx < 0) {
                        widget.tableItemProvidor.zeroAmountInCard(context: context);
                      }
                    }
                    Future.delayed(const Duration(milliseconds: 100), () {
                      onSwipe = false;
                    });
                  },
                  child: SizedBox(
                    width: widget.width * 0.23,
                    height: widget._height-4,
                    // //color: Colors.blue,
                    // decoration: BoxDecoration(
                    //   border: Border.all(color: Colors.black, width: 0.5),
                    //   borderRadius:
                    //       const BorderRadius.all(Radius.circular(15.0)),
                    // ),
                    child: Center(
                      child: Text(
                        widget.tableItemProvidor
                                .getTotalPrice(context: context)
                                .toStringAsFixed(2) +
                            "€",
                        style: const TextStyle(
                          fontSize: 20,
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              //That is the Amount Field
              AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.fastOutSlowIn,
                left: (widget.width *
                    widget.pos_percentage_field_amount_1[
                    widget.tableItemProvidor.getPaymode()]!),
                child: GestureDetector(
                  onTap: () {
                    if (widget.tableItemProvidor.getPaymode()) {
                      widget.tableItemProvidor.addAmountInCard(amount: 1, context: context);
                    }
                  },
                  child: Container(
                    width: widget.width * 0.10,
                    height: widget._height-4,
                    //color: Colors.blue,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.tableItemProvidor.getPaymode()
                            ? widget.tableItemProvidor.getAmountInCard().toString()
                            : widget.tableItemProvidor.quantity.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              //That is the Field with the Product Description
              AnimatedPositioned(
                duration: const Duration(milliseconds: 900),
                curve: Curves.fastOutSlowIn,
                top: 0,
                left: (widget.width *
                    widget.pos_percentage_field_description_1[
                    widget.tableItemProvidor.getPaymode()]!),
                //     bottom: 10,
                child: SizedBox(
                  width: widget.width * 0.55,
                  height: widget._height-4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 10,
                        width: widget.width * 0.6,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              widget.tableItemProvidor.getPaymode()
                                  ? Text(
                                      (widget.tableItemProvidor.quantity -
                                          widget.tableItemProvidor
                                                      .getAmountInCard())
                                              .toString() +
                                          " remain ",
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    )
                                  : Container(),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                      widget.tableItemProvidor.getAmountInCard(),
                                      (index) => Padding(
                                        padding: const EdgeInsets.only(left: 3),
                                        child: Container(
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(
                                            color:
                                            widget.tableItemProvidor.getPaymode()
                                                    ? Colors.black38
                                                    : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            // boxShadow: [
                                            //   BoxShadow(
                                            //     color: widget.tableItemProvidor
                                            //             .getPaymode()
                                            //         ? const Color(0xFFD3E03A)
                                            //             .withOpacity(0.3)
                                            //         : Colors.lightBlueAccent
                                            //             .withOpacity(0.35),
                                            //     spreadRadius: 1,
                                            //     blurRadius: 5,
                                            //     offset: const Offset(
                                            //         2, 2), // Shadow position
                                            //   ),
                                            // ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                      widget.tableItemProvidor.quantity -
                                          widget.tableItemProvidor.getAmountInCard(),
                                      (index) => Padding(
                                        padding: const EdgeInsets.only(left: 3),
                                        child: Container(
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(
                                            color:
                                            widget.tableItemProvidor.getPaymode()
                                                    ? Colors.white
                                                    : Colors.black38,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            // boxShadow: [
                                            //   BoxShadow(
                                            //     color: widget.tableItemProvidor
                                            //             .getPaymode()
                                            //         ? Colors.lightBlueAccent
                                            //             .withOpacity(0.35)
                                            //         : const Color(0xFFD3E03A)
                                            //             .withOpacity(0.3),
                                            //     spreadRadius: 1,
                                            //     blurRadius: 5,
                                            //     offset: const Offset(
                                            //         2, 2), // Shadow position
                                            //   ),
                                            // ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      //SizedBox(height: 5,),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          productProvidor.findById(widget.tableItemProvidor.product).name,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.tableItemProvidor.getExtrasWithSemicolon(
                                  context: context),
                              overflow: TextOverflow.fade,
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
