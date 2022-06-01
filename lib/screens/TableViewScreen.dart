import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inspery_pos/widgets/table/menu/ChooseDips.dart';
import 'package:inspery_pos/widgets/table/menu/ChooseExtraOptionsWidget.dart';
import 'package:inspery_pos/widgets/table/menu/ChooseProductSize.dart';
import 'package:provider/provider.dart';
import '../Providers/TableItemChangeProvidor.dart';
import '../widgets/table/TableOverviewFrame.dart';
import '../widgets/table/menu/ChooseProductFormWidget.dart';
import '../widgets/table/menu/ChooseSideProduct.dart';

class TableView extends StatefulWidget {
  static const routeName = '/table-view';
  TableView({Key? key}) : super(key: key);


  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> with TickerProviderStateMixin{
  // const TableView({Key? key}) : super(key: key);


  // Animation
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  goToNextPos({required String indicator, bool stay = false}){
    print("############");
    print("Go to next pos: " + indicator.toString());
    setState(() {
      if((buttonNames.length-1) < actPos){
        buttonNames.add(indicator);
      }
      else{
        buttonNames[actPos] = indicator;
      }
      if(stay) return;
      actPos++;
      horizontalScrollController.animateTo(
          MediaQuery.of(context).size.width * actPos,
          duration:  const Duration(milliseconds: 500),
          curve: Curves.easeInOutQuart);
      horizontalScrollControllerSteps.animateTo(
          actPos * 35,
          duration:  const Duration(milliseconds: 200),
          curve: Curves.easeInOutQuart);
    });
  }

  int actPos = 0;
  ScrollController horizontalScrollController = ScrollController();
  ScrollController horizontalScrollControllerSteps = ScrollController();
  List<String> buttonNames = [];

  @override
  Widget build(BuildContext context) {

    final id = int.parse(ModalRoute.of(context)?.settings.arguments
    as String); //the id we got from the Link

    final int tableId = id;

    final Map<String, Widget> chooseProductWidget = {
      "Product" : SizedBox(
        width: MediaQuery.of(context).size.width,
        height: (MediaQuery.of(context).size.height / 2)-40,
        child: ChooseProductForm(tableName: tableId, goToNextPos: goToNextPos, categorieTypeLeft: "food", categorieTypeRight: "drinks",),
      ),
      "Size" : SizedBox(
        width: MediaQuery.of(context).size.width,
        height: (MediaQuery.of(context).size.height / 2) -40,
        child: ChooseProductSize(tableName: tableId, goToNextPos: goToNextPos,),
      ),
      "Beilagen" : SizedBox(
        width: MediaQuery.of(context).size.width,
        height: (MediaQuery.of(context).size.height / 2) -40,
        child: ChooseSideProduct(tableName: tableId, goToNextPos: goToNextPos,),
      ),
      "Dips" :SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2 - 40,
        child: ChooseDips(tableName: tableId, goToNextPos: goToNextPos,),
      ),
      "Extras" :SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2 - 40,
        child: ChooseExtraOptionWidget(tableName: tableId),
      ),
    };


    return
      Scaffold(
        body: Container(
          color: Theme.of(context).primaryColorDark,
          child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF5F2E7),//Theme.of(context).primaryColorDark
              ),
              child: Column(children: [
                TableOverviewWidgetFrame(
                  height: (MediaQuery.of(context).size.height / 2 - 20),
                  height_expended: MediaQuery.of(context).size.height - 5,
                  width: MediaQuery.of(context).size.width,
                  id: tableId,
                ),
                Expanded(child: Column(
                  children: [
                    SingleChildScrollView(
                        controller: horizontalScrollController,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        child: Row(
                          children: chooseProductWidget.values.toList(),
                        )
                    ),
                    SizedBox(
                      height: 38,
                      child:
                      Row(
                        children: [
                          Flexible(
                            child: ListView.builder(
                              controller: horizontalScrollControllerSteps,
                              scrollDirection: Axis.horizontal,
                              itemCount:chooseProductWidget.length,
                              itemBuilder: (context, index) =>
                              //index == chooseProductWidget.length ?

                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    actPos = index;
                                    horizontalScrollController.animateTo(
                                        MediaQuery.of(context).size.width * actPos,
                                        duration:  const Duration(milliseconds: 500),
                                        curve: Curves.easeInOutQuart);
                                     horizontalScrollControllerSteps.animateTo(
                                         actPos * 35,
                                         duration:  const Duration(milliseconds: 200),
                                         curve: Curves.easeInOutQuart);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Container(
                                      width: 75,
                                      padding: const EdgeInsets.only(right: 5, left: 5),
                                      decoration: BoxDecoration(
                                        color: actPos == index? const Color(0xFFD3E03A) : const Color(0xFFF3F3F3),
                                        borderRadius: BorderRadius.circular(20),
                                        border: buttonNames.length > index ? Border.all() : null,
                                      ),
                                      child: Center(
                                          child: Text(
                                              (buttonNames.length > index ? buttonNames[index] : /*(index+1).toString() + "." + */ chooseProductWidget.keys.toList()[index]),
                                          style: const TextStyle(fontSize: 10,),
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
                                onTap: (){
                                  Provider.of<TableItemChangeProvidor>(context, listen: false).showProduct(index: null, context: context);
                                  setState(() {
                                    actPos = 0;
                                    buttonNames = [];
                                    horizontalScrollController.animateTo(
                                        0,
                                        duration:  const Duration(milliseconds: 500),
                                        curve: Curves.easeInOutQuart);
                                    horizontalScrollControllerSteps.animateTo(
                                        0,
                                        duration:  const Duration(milliseconds: 200),
                                        curve: Curves.easeInOutQuart);
                                  });
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
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Icon(Icons.arrow_circle_up, color: Colors.black.withOpacity(0.4),),
                                        ),
                                        const SizedBox(width: 5,),
                                        const Text("Fertig"),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),

                    ),

                  ],

                ),

                ),
              ],
              )
          ),
        ),
      );
  }
}
