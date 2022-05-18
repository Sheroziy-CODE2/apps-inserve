import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/table/TableOverviewFrame.dart';
import '../widgets/table/menu/ChooseProductFormWidget.dart';
import '../widgets/NavBar.dart';

class TableView extends StatelessWidget {
  static const routeName = '/table-view';
  TableView({Key? key}) : super(key: key);

  // const TableView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive); //leanBack

    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);  // to re-show bars


    final id = int.parse(ModalRoute.of(context)?.settings.arguments
        as String); //the id we got from the Link

    final int tableId = id;

    return
      Scaffold(
      body: Container(
        color: Theme.of(context).primaryColorDark,
        child: Container(
          decoration: const BoxDecoration(
              color: Color(0xFFF5F2E7),//Theme.of(context).primaryColorDark
          ),
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            TableOverviewWidgetFrame(
              height: (MediaQuery.of(context).size.height / 2),
              height_expended: MediaQuery.of(context).size.height - 77,
              width: MediaQuery.of(context).size.width,
              id: tableId,
            ),
            Expanded(
              child: ChooseProductForm(tableName: tableId),
            ),
          ]),
        ),
      ),
    );
  }
}
