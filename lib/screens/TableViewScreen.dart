import 'package:flutter/material.dart';
import '/Providers/Products.dart';
import '/widgets/table/menu/ChooseExtraOptionsWidget.dart';
import '/widgets/table/menu/ChooseProductSize.dart';
import 'package:provider/provider.dart';
import '../Providers/TableItemChangeProvidor.dart';
import '../Providers/TableItemProvidor.dart';
import '../Providers/TableItemsProvidor.dart';
import '../Providers/Tables.dart';
import '../widgets/table/TableOverviewFrame.dart';
import '../widgets/table/menu/ChooseProductFormWidget.dart';
import '../widgets/table/menu/ChooseSideProduct.dart';

class TableView extends StatefulWidget {
  static const routeName = '/table-view';
  const TableView({Key? key}) : super(key: key);

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> with TickerProviderStateMixin {
  Map<String, Widget> chooseProductWidget = {};
  late TableItemChangeProvidor tableItemChangeProvidor;

  int? actItem;
  bool comeFromProduct = false;

  goToNextPos(
      {required String indicator,
        bool stay = false,
        bool dontStoreIndicator = false}) {
    print("Go to next pos: " + indicator.toString());
    setState(() {
      if (!dontStoreIndicator) {
        //This it not working for now.. so it is unused.. maybe i will implement it later - Andi 22.06
        while((buttonNames.length - 1) < actPos){
          buttonNames.add("");
        }
        if ((buttonNames.length - 1) < actPos) {
          buttonNames.add(indicator);
        } else {
          buttonNames[actPos] = indicator;
        }
      }
      if (stay) return;
      actPos++;
      if (chooseProductWidget.length <= actPos) {
        productReadyToEnter();
        return;
      }
      horizontalScrollController.animateTo(
          MediaQuery.of(context).size.width * actPos,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutQuart);
      if (actPos > 1) {
        horizontalScrollControllerSteps.animateTo(actPos * 35,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOutQuart);
      }
    });
  }

  productReadyToEnter({bool skipAnimation = false}) {
    tableItemChangeProvidor.showProduct(index: null, context: context);
    actItem = null;
    setState(() {
      actPos = 0;
      buttonNames = [];
      if(!skipAnimation){
        horizontalScrollController.animateTo(0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutQuart);
        horizontalScrollControllerSteps.animateTo(0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOutQuart);
      }
    });
  }

  int actPos = 0;
  String posName = "";
  ScrollController horizontalScrollController = ScrollController();
  ScrollController horizontalScrollControllerSteps = ScrollController();
  List<String> buttonNames = [];
  int lastSelectedItem = 0;

  Widget getElements(
      {required String key, required tableId, required context}) {
    final Map<String, Widget> chooseProductWidget = {
      "Produkt": SizedBox(
        width: MediaQuery.of(context).size.width,
        height: (MediaQuery.of(context).size.height / 2),
        child: ChooseProductForm(
          tableName: tableId,
          goToNextPos: goToNextPos,
          categorieTypeLeft: "food",
          categorieTypeRight: "drinks",
          //key: chooseProductForm_key,
        ),
      ),
      "Größe": SizedBox(
        width: MediaQuery.of(context).size.width,
        height: (MediaQuery.of(context).size.height / 2) - 40,
        child: ChooseProductSize(
          tableName: tableId,
          goToNextPos: goToNextPos,
        ),
      ),
      "Zusatz": SizedBox(
        width: MediaQuery.of(context).size.width,
        height: (MediaQuery.of(context).size.height / 2) - 40,
        child: ChooseSideProduct(
          tableName: tableId,
          goToNextPos: goToNextPos,
        ),
      ),
      // "Dips": SizedBox(
      //   width: MediaQuery.of(context).size.width,
      //   height: MediaQuery.of(context).size.height / 2 - 40,
      //   child: ChooseDips(
      //     tableName: tableId,
      //     goToNextPos: goToNextPos,
      //   ),
      // ),
      "Extras": SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2 - 40,
        child: ChooseExtraOptionWidget(tableName: tableId),
      ),
    };
    return chooseProductWidget[key]!;
  }

  late TableItemProvidor tableItemProvidor;
  late TableItemsProvidor tIP;

  @override
  Widget build(BuildContext context) {
    final id = int.parse(ModalRoute.of(context)?.settings.arguments as String); //the id we got from the Link
    final int tableId = id;

    //generating the set of Widgets for the selected Product
    tableItemChangeProvidor =
        Provider.of<TableItemChangeProvidor>(context, listen: true);
    chooseProductWidget = {};
    try {
      tIP = Provider.of<Tables>(context, listen: true).findById(tableId).tIP;
      actItem = tableItemChangeProvidor.getActProduct()!;

      tableItemProvidor = tIP.tableItems[actItem!];
      var product = Provider.of<Products>(context, listen: true)
          .findById(tableItemProvidor.product);
      if (product.product_price.where((element) => !element.isSD).length > 1) {
        chooseProductWidget.putIfAbsent(
            "Größe",
                () =>
                getElements(key: "Größe", tableId: tableId, context: context));
      }
      if (product.productSelection.isNotEmpty) {
        chooseProductWidget.putIfAbsent(
            "Zusatz",
                () => getElements(
                key: "Zusatz", tableId: tableId, context: context));
      }
      // if (product.dips_number > 0) {
      //   chooseProductWidget.putIfAbsent("Dips",
      //           () => getElements(key: "Dips", tableId: tableId, context: context));
      // }
      if(tableItemChangeProvidor.selectedProcuctManual) {
        chooseProductWidget.putIfAbsent("Extras", () => getElements(key: "Extras", tableId: tableId, context: context));
      }
      if (lastSelectedItem != actItem) {
        //when select other item in List
        buttonNames = [];
        try {
          actPos = chooseProductWidget.keys.toList().indexOf(posName);
          if (actPos == -1) actPos = 0;
        } catch (e) {
          actPos = 0;
        }
        horizontalScrollController.animateTo(
            MediaQuery.of(context).size.width * actPos,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutQuart);
        if (actPos > 1) {
          horizontalScrollControllerSteps.animateTo(actPos * 35,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOutQuart);
        }
      }
      lastSelectedItem = actItem!;
    } catch (e) {
      chooseProductWidget.putIfAbsent("Produkt", () => getElements(key: "Produkt", tableId: tableId, context: context));
    }
    if (actPos != -1) {
      try {
        posName = chooseProductWidget.keys.toList()[actPos];
      } catch (e) {
        actPos = 0;
      }
    }
    if(chooseProductWidget.keys.isEmpty){
      productReadyToEnter(skipAnimation: true);
      chooseProductWidget.putIfAbsent("Produkt", () => getElements(key: "Produkt", tableId: tableId, context: context));
    }
    //try {
    //  chooseProductForm_key.currentState!.changeCategory(287);
    //}catch(e){}

    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColorDark,
        child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF5F2E7), //Theme.of(context).primaryColorDark
            ),
            child: Column(
              children: [
                TableOverviewWidgetFrame(
                  height: (MediaQuery.of(context).size.height / 2 - 20),
                  height_expended: MediaQuery.of(context).size.height - 5,
                  width: MediaQuery.of(context).size.width,
                  id: tableId,
                ),
                Expanded(
                  child: Column(
                    children: [
                      SingleChildScrollView(
                          controller: horizontalScrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          child: Row(
                            children: chooseProductWidget.values.toList(),
                          )),
                      chooseProductWidget.keys
                          .where((element) => element != "Produkt")
                          .isNotEmpty
                          ? SizedBox(
                        height: 38,
                        child: Row(
                          children: [
                            Flexible(
                              child: ListView.builder(
                                controller:
                                horizontalScrollControllerSteps,
                                scrollDirection: Axis.horizontal,
                                itemCount: chooseProductWidget.length,
                                itemBuilder: (context, index) =>
                                //index == chooseProductWidget.length ?

                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      actPos = index;
                                      horizontalScrollController
                                          .animateTo(
                                          MediaQuery.of(context)
                                              .size
                                              .width *
                                              actPos,
                                          duration: const Duration(
                                              milliseconds: 500),
                                          curve:
                                          Curves.easeInOutQuart);
                                      if (actPos > 1) {
                                        horizontalScrollControllerSteps
                                            .animateTo(actPos * 35,
                                            duration: const Duration(
                                                milliseconds: 200),
                                            curve: Curves
                                                .easeInOutQuart);
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Container(
                                        width: 75,
                                        padding: const EdgeInsets.only(
                                            right: 5, left: 5),
                                        decoration: BoxDecoration(
                                          color: actPos == index
                                              ? const Color(0xFFD3E03A)
                                              : const Color(0xFFF3F3F3),
                                          borderRadius:
                                          BorderRadius.circular(20),
                                          border:
                                          buttonNames.length > index
                                              ? Border.all()
                                              : null,
                                        ),
                                        child: Center(
                                            child: Text(
                                              (
                                                  //buttonNames.length > index
                                                  //? buttonNames[index]
                                                  //: /*(index+1).toString() + "." + */
                                                  chooseProductWidget
                                                      .keys
                                                      .toList()[index]),
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ))),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3),
                              child: SizedBox(
                                height: 40,
                                width: 100,
                                child: GestureDetector(
                                  onTap: () {
                                    productReadyToEnter();
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: tableItemChangeProvidor
                                            .getActProduct() !=
                                            null
                                            ? const Color(0xFFD3E03A)
                                            : Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: tableItemChangeProvidor
                                                  .getActProduct() !=
                                                  null
                                                  ? const Color(
                                                  0xFFE3F05A)
                                                  : const Color(
                                                  0xFFF3F3F3),
                                              borderRadius:
                                              BorderRadius.circular(
                                                  20),
                                            ),
                                            child: Icon(
                                              Icons.arrow_circle_up,
                                              color: Colors.black
                                                  .withOpacity(0.4),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Text("Fertig"),
                                        ],
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          : Container(),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
