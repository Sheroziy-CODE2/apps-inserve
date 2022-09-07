import 'package:flutter/material.dart';
import '../widgets/table/TableItemWidget.dart';
import 'package:provider/provider.dart';
import '../Providers/Tables.dart';
import '../widgets/NavBar.dart';
import '../widgets/table/tables/TablesNotificationWidget.dart';
import 'TableChangePopUp.dart';
import 'WeiterChangePopUp.dart';

class TablesView extends StatefulWidget {
  static const routeName = '/tables-view';

  const TablesView({Key? key}) : super(key: key);
  @override
  State<TablesView> createState() => _TablesViewState();
}

class _TablesViewState extends State<TablesView> {
  final _isInit = true;
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
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.bottomRight,
                //stops: const [0, 1],
                colors: [
                  const Color(0x00535353).withOpacity(.8),
                  const Color(0xFF535353).withOpacity(.1)
                ])),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //const Text("Offene Tische", style: TextStyle(fontSize: 16),),
              Row(
                children: <Widget>[
                  SizedBox(
                    height: 40,
                      width: MediaQuery.of(context).size.width/2,
                      child: TablesNotificationWidget()
                  ),
                  const Spacer(),
                  IconButton(
                    padding: const EdgeInsets.only(right: 15),
                    icon: const Icon(Icons.multiple_stop, size: 28,color: Color(0xFF7B7B7B),),
                    onPressed: () { TableChange.getInstance()?.showTableChangeDialog(context);
                      },
                  ),
                  IconButton(
                    padding: const EdgeInsets.only(right: 15),
                    icon: const Icon(Icons.supervised_user_circle_outlined, size: 28,color: Color(0xFF7B7B7B)),
                    onPressed: () { WeiterChange.getInstance()?.showWeiterChangeDialog(context);
                      },
                  ),
                  IconButton(
                    padding: const EdgeInsets.only(right: 15),
                    icon: const Icon(Icons.settings, size: 28,color: Color(0xFF7B7B7B)),
                    onPressed: () {},
                  ),
                ],
              ),
              Expanded(
                child: _isLoading
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: opendTables.length,
                    itemBuilder: (context, i) => TableItem(
                      id: opendTables[i].id,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
