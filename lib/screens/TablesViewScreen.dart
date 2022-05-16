import 'package:flutter/material.dart';
import '../widgets/table/TableItemWidget.dart';

import 'package:provider/provider.dart';
import '../Providers/Tables.dart';

import '../widgets/NavBar.dart';

class TablesView extends StatefulWidget {
  // const TablesView({Key? key}) : super(key: key);
  static const routeName = '/tables-view';

  @override
  State<TablesView> createState() => _TablesViewState();
}

class _TablesViewState extends State<TablesView> {
  var _isInit = true;
  var _isLoading = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      setState(() {
        _isLoading = false;
      });
    }
    super.didChangeDependencies();
  }

  // const  ({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final tablesData = Provider.of<Tables>(context);
    final opendTables = tablesData.items;

    for (int i = 0;
        opendTables.length != null ? i < opendTables.length : i > 5;
        i++) {}
    return Scaffold(
      bottomNavigationBar: const NavBar(selectedIcon: 2),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: Theme.of(context).cardColor,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: opendTables.length,
                itemBuilder: (context, i) => TableItem(
                  id: opendTables[i].id,
                ),
              ),
            ),
    );
  }
}
