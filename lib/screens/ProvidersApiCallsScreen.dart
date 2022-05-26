import 'package:flutter/material.dart';
import '../Providers/Authy.dart';

import 'package:provider/provider.dart';
import '../Providers/SideProducts.dart';
import '../Providers/Tables.dart';
import '../Providers/Categorys.dart';
import '../Providers/Ingredients.dart';
import '../Providers/Products.dart';
import './HomePageScreen.dart';

class ProvidersApiCalls extends StatefulWidget {
  // const LoadProviders({Key? key}) : super(key: key);
  static const routeName = '/Load-providers';

  @override
  State<ProvidersApiCalls> createState() => _ProvidersApiCallsState();
}

class _ProvidersApiCallsState extends State<ProvidersApiCalls> {
  var _isInit = true;
  var _isLoading = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // get all the tables
    // later it should be only opened tables
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      loadProviders();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading == true
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : const HomePage();
  }

  Future<void> loadProviders() async {
    // to load all the data that the user needs
    final tablesData = Provider.of<Tables>(context, listen: false);
    final token = Provider.of<Authy>(context, listen: false).token;
    await {
      tablesData.addTabl(token: token).then((_) async {
        Provider.of<Categorys>(context, listen: false).addCategory(context: context);
        final token_provider = Provider.of<Authy>(context, listen: false);
        _isInit = false;
        final token = token_provider.token;
        Provider.of<Ingredients>(context, listen: false).addIngredients(token: token, context: context);
        //Provider.of<Prices>(context, listen: false).addPrices(token: token);
        Provider.of<SideProducts>(context, listen: false).addSideProducts(token: token);
        Provider.of<Products>(context, listen: false).addProducts(token: token, context: context);

        for (var i = 0; i < tablesData.items.length; i++) {
          var table = tablesData.items[i];
          await tablesData.connectSocket(
              id: table.id, context: context, token: token);
          await tablesData.listenSocket(
              id: table.id, context: context, token: token);
        }
        setState(() {
          _isLoading = false;
        });
      })
    };
  }
}
