
import 'package:flutter/material.dart';
import 'package:inspery_pos/widgets/table/TableOverviewChangeProduct.dart';
import 'package:inspery_pos/widgets/table/TableOverviewProductList.dart';

import 'package:provider/provider.dart';
import '../../Models/TableModel.dart';
import '../../Providers/TableItemsProvidor.dart';
import '../../Providers/Tables.dart';

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
        padding: const EdgeInsets.all(5),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 450),
          curve: Curves.fastOutSlowIn,
          height:
              (tableItemProvidor.hight_mode_extendet ? widget.height_expended : widget.height) -
                  10,
          width: widget.width - 10,
          decoration: BoxDecoration(
            color: const Color.fromARGB(30, 0, 0, 0),
            borderRadius: BorderRadius.circular(11),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF395B64).withOpacity(0.3),
                spreadRadius: -3,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: isloading
              ? Center(
                  child: Column(children: const [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Tischdaten laden ...",
                    style: TextStyle(color: Colors.white),
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
                    Center(
                      child: Row(
                        children: [
                          Text(table.name,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white)),
                          const Spacer(),
                          Text(paymode ? "Zahlen" : "Offen",
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white)),
                          const Spacer(),
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
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white)),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    //const SizedBox(height: 5,),
                    TableOverviewProductList(id: widget.id),
                    selectedItem != -1
                        ? const SizedBox(
                            height: 5,
                          )
                        : Container(),
                    TableOverviewChangeProduct(
                        height: widget.height,
                        width: widget.width,
                        height_expended: widget.height_expended,
                        tableID: widget.id),
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        paymode ?
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(50, 10, 10, 10),
                          ),
                          onPressed: () {
                            tableItemProvidor.setItemsPaymode(
                              context: context,
                                paymode: !paymode);
                            setState(() {
                              paymode = !paymode;
                              tableItemProvidor.setHightModeExtendet(hight_mode_extendet: false, context: context);
                            });
                          },
                          child: const Text("Zurück"),
                        ) :Container(),
                        const Spacer(),
                        paymode
                            ? FloatingActionButton.small(
                                backgroundColor:
                                    const Color.fromARGB(1050, 10, 10, 10),
                                onPressed: () {
                                  tableItemProvidor.setItemsAmountToPayToZero(context: context);
                                },
                                //backgroundColor: Colors.green,
                                child: const Icon(Icons.delete_forever),
                              )
                            : Container(),
                        const SizedBox(
                          width: 10,
                        ),
                        paymode
                            ? FloatingActionButton.small(
                                backgroundColor:
                                    const Color.fromARGB(100, 0, 0, 0),
                                onPressed: () {
                                  tableItemProvidor
                                      .setItemsAmountToPayToTotal(context: context);
                                },
                                //backgroundColor: Colors.green,
                                child: const Icon(Icons.done_all),
                              )
                            : FloatingActionButton.small(
                          backgroundColor: const Color.fromARGB(100, 0, 0, 0),
                          onPressed: () {
                            tableItemProvidor.setHightModeExtendet(hight_mode_extendet: !tableItemProvidor.hight_mode_extendet, context: context);
                          },
                          //backgroundColor: Colors.green,
                          child: const Icon(Icons.expand),
                        ),
          const SizedBox(
            width: 10,
          ),
                        const SizedBox(
                          width: 10,
                        ),
                        paymode
                            ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary:
                            const Color.fromARGB(100, 10, 10, 10),
                          ),
                          onPressed: () async {
                            await tablesprov.checkout(context: context, tableID: widget.id);
                          },
                          child: const Text("Abrechnen"),
                        )
                            :

                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromARGB(50, 10, 10, 10),
                              ),
                              onPressed: () {
                                tablesprov.checkoutItemsToSocket(context:context,tableID:widget.id);
                              },
                              child: const Text("Übertragen"),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromARGB(50, 10, 10, 10),
                              ),
                              onPressed: () {
                                tableItemProvidor.setItemsPaymode(
                                    context: context,
                                    paymode: !paymode);
                                  paymode = !paymode;
                                tableItemProvidor.setHightModeExtendet(hight_mode_extendet: true, context: context);

                              },
                              child: const Text(" Zahlen "),
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
    print('on dispose');
    tableItemProvidor.setItemsPaymode(context: context, paymode: false);
    tableItemProvidor.setHightModeExtendet(hight_mode_extendet: false, context: context);
    tablesprov.checkoutItemsToSocket(context:context,tableID:widget.id);
    super.dispose();
  }
}
