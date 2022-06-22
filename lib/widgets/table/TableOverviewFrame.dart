import 'package:flutter/material.dart';
import '/widgets/table/TableOverviewProductList.dart';

import 'package:provider/provider.dart';
import '../../Models/TableModel.dart';
import '../../Providers/TableItemChangeProvidor.dart';
import '../../Providers/TableItemsProvidor.dart';
import '../../Providers/Tables.dart';
import '../../main.dart';

//we have to rename this widget
class TableOverviewWidgetFrame extends StatefulWidget {
  const TableOverviewWidgetFrame(
      {required this.height,
      required this.height_expended,
      required this.id,
      Key? key,
      required this.width})
      : super(key: key);
  final double height;
  final double height_expended;
  final double width;
  final int id;
  @override
  _TableOverviewWidgetStateFrame createState() =>
      _TableOverviewWidgetStateFrame();
}

class _TableOverviewWidgetStateFrame extends State<TableOverviewWidgetFrame> {
  _TableOverviewWidgetStateFrame();
  late Tables tablesprov;

  //bool hight_mode_extendet = false;
  bool isloading = false;
  int selectedItem = -1; // dieses Produkt ist konfigurierbar

  ScrollController slideController = ScrollController();
  Map<int, int> amountOfProductsInCard = {};

  bool paymode = false;
  late TableItemsProvidor tableItemProvidor;

  @override
  Widget build(BuildContext context) {
    tablesprov = Provider.of<Tables>(context, listen: true);
    final TableModel table = tablesprov.findById(widget.id);
    tableItemProvidor = table.tIP;

    return Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 15),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 450),
          curve: Curves.fastOutSlowIn,
          height: (tableItemProvidor.hight_mode_extendet
                  ? widget.height_expended
                  : widget.height) -
              10,
          width: widget.width - 10,
          /*decoration: BoxDecoration(
            color: const Color.fromARGB(255, 245, 242, 231),
            borderRadius: BorderRadius.circular(11),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF395B64).withOpacity(0.3),
                spreadRadius: -3,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),*/
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(begin: Alignment.bottomRight,
                  //stops: const [0, 1],
                  colors: [
                    const Color(0x00C4C4C4).withOpacity(.8),
                    const Color(0xFFC4C4C4).withOpacity(.1)
                  ])),
          child: isloading
              ? Center(
                  child: Column(children: const [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Tischdaten laden ...",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  CircularProgressIndicator(),
                ]))
              : Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Tisch",
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(table.name,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ],
                        ),
                        const Spacer(),
                        Text(paymode ? "Zahlen" : "Offen",
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black)),
                        const Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "Betray",
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                                (paymode
                                            ? tableItemProvidor
                                                .getTotalCartTablePrice(
                                                    context: context)
                                            : tableItemProvidor
                                                .getTotalOpenTablePrice(
                                                    context: context))!
                                        .toStringAsFixed(2) +
                                    "€",
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                    //const SizedBox(height: 5,),
                    TableOverviewProductList(id: widget.id),
                    // selectedItem != -1
                    //     ? const SizedBox(
                    //   height: 5,
                    // )
                    //     : Container(),
                    // TableOverviewChangeProduct(
                    //     height: widget.height,
                    //     width: widget.width,
                    //     height_expended: widget.height_expended,
                    //     tableID: widget.id),
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        paymode
                            ? SizedBox(
                                height: 40,
                                width: 110,
                                child: GestureDetector(
                                  onTap: () {
                                    Provider.of<TableItemChangeProvidor>(context, listen: false).showProduct(index: null, context: context);
                                    tableItemProvidor.setItemsPaymode(
                                        paymode: !paymode);
                                    setState(() {
                                      paymode = !paymode;
                                      tableItemProvidor.setHightModeExtendet(
                                        hight_mode_extendet: false,
                                      );
                                    });
                                    Provider.of<Tables>(context, listen: false)
                                        .notify();
                                     },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF3F3F3),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Icon(
                                              Icons.arrow_back_ios,
                                              color:
                                                  Colors.black.withOpacity(0.4),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Text("Zurück"),
                                        ],
                                      )),
                                ),
                              )
                            : Container(),
                        const Spacer(),
                        paymode
                            ? GestureDetector(
                                onTap: () {
                                  tableItemProvidor.setItemsAmountToPayToZero(
                                      context: context);
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F3F3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.delete_forever,
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                ),
                              )
                            : Container(),
                        const SizedBox(
                          width: 6,
                        ),
                        paymode
                            ? GestureDetector(
                                onTap: () {
                                  tableItemProvidor.setItemsAmountToPayToTotal(
                                      context: context);
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F3F3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.done_all,
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 40,
                                width: 105,
                                child: GestureDetector(
                                  onTap: () {
                                    tableItemProvidor.setHightModeExtendet(
                                        hight_mode_extendet: !tableItemProvidor
                                            .hight_mode_extendet);
                                    Provider.of<Tables>(context, listen: false)
                                        .notify();
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF3F3F3),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Icon(
                                              tableItemProvidor
                                                      .hight_mode_extendet
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color:
                                                  Colors.black.withOpacity(0.4),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Text("Menü"),
                                        ],
                                      )),
                                ),
                              ),
                        const SizedBox(
                          width: 6,
                        ),
                        paymode
                            ? SizedBox(
                                height: 40,
                                width: 127,
                                child: GestureDetector(
                                  onTap: () async {
                                    await tablesprov.checkout(
                                        context: context, tableID: widget.id);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF3F3F3),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Icon(
                                              Icons.credit_card,
                                              color:
                                                  Colors.black.withOpacity(0.4),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Text("Abrechnen"),
                                        ],
                                      )),
                                ),
                              )
                            : Row(
                                children: [
                                  tablesprov.isItemFromWaiter(
                                          tableID: widget.id)
                                      ? SizedBox(
                                          height: 40,
                                          width: 130,
                                          child: GestureDetector(
                                            onTap: () {
                                              tablesprov.checkoutItemsToSocket(
                                                  context: context,
                                                  tableID: widget.id);
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xFFF3F3F3),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Icon(
                                                        Icons.send,
                                                        color: Colors.black
                                                            .withOpacity(0.4),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    const Text("Übertragen"),
                                                  ],
                                                )),
                                          ),
                                        )
                                      : Container(),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  SizedBox(
                                    height: 40,
                                    width: 105,
                                    child: GestureDetector(
                                      onTap: () {
                                        tableItemProvidor.setItemsPaymode(
                                            paymode: !paymode);
                                        paymode = !paymode;
                                        tableItemProvidor.setHightModeExtendet(
                                            hight_mode_extendet: true);
                                        Provider.of<Tables>(context,
                                                listen: false)
                                            .notify();
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFF3F3F3),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Icon(
                                                  Icons.credit_card_sharp,
                                                  color: Colors.black
                                                      .withOpacity(0.4),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              const Text("Zahlen"),
                                            ],
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    )
                  ],
                ),
        ));

    //);
  }

  @override
  void dispose() {
    print('TableOverviewFrame dispose');
    try {
      tableItemProvidor.setItemsPaymode(paymode: false);
    } catch (e) {
      print("#Have to be fixed# 1 TableOverviewFrame dispose: " + e.toString());
    }
    try {
      tableItemProvidor.setHightModeExtendet(hight_mode_extendet: false);
    } catch (e) {
      print("#Have to be fixed# 2 TableOverviewFrame dispose: " + e.toString());
    }
    try {
      tablesprov.checkoutItemsToSocket(
          context: context, tableID: widget.id, reload: false);
    } catch (e) {
      print("#Have to be fixed# 3 TableOverviewFrame dispose: " + e.toString());
    }
    print(context);
    final _context = MyApp.navKey.currentContext;
    if (_context == null) {
      print(
          "Global context in checkState on dispose TableOverviewFrame is null");
      return;
    }
    try {
      Provider.of<TableItemChangeProvidor>(_context, listen: false)
          .showProduct(index: null, context: _context);
    } catch (e) {
      print("#Have to be fixed# 4 TableOverviewFrame dispose: " + e.toString());
    }
    super.dispose();
  }
}
