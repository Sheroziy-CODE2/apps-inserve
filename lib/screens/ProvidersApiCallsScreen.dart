import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../Providers/Authy.dart';
import 'package:provider/provider.dart';
import '../Providers/Tables.dart';
import '../Providers/Categorys.dart';
import '../Providers/Ingredients.dart';
import '../Providers/Products.dart';
import '../Providers/WorkersProvider.dart';
import './HomePageScreen.dart';

class ProvidersApiCalls extends StatefulWidget {
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
        ? Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
      child: Lottie.asset('assets/lottie/cateringfork-knife.json'),
    ),
          ),
        )
        : const HomePage();
  }

  Future<void> loadProviders() async {
    // to load all the data that the user needs
    final tablesData = Provider.of<Tables>(context, listen: false);
    final token = Provider.of<Authy>(context, listen: false).token;
    {
      tablesData.addTabl(token: token).then((_) async {
        final tokenProvider = Provider.of<Authy>(context, listen: false);
        final token = tokenProvider.token;
        await Provider.of<Categorys>(context, listen: false)
            .addCategory(context: context, token: token);
        _isInit = false;
        await Provider.of<Ingredients>(context, listen: false)
            .addIngredients(token: token, context: context);
        await Provider.of<Products>(context, listen: false)
            .addProducts(token: token, context: context);
        //await Provider.of<DipsProvider>(context, listen: false).addDips(token: token, context: context); Remove Dips 27.07 Andi
        await Provider.of<WorkersProvider>(context, listen: false)
            .addWorkers(token: token, context: context);

        await tablesData.connectALlTablesSocket(context: context, token: token);
        // await tablesData.listenToAllTabelsSocket(
        //     context: context, token: token);
        for (var i = 0; i < tablesData.items.length; i++) {
          var table = tablesData.items[i];
          await tablesData.connectSocket(
              id: table.id, context: context, token: token);
          // await tablesData.listenSocket(
          //     id: table.id, context: context, token: token);
        }
        setState(() {
          _isLoading = false;
        });
      });
    }
  }
}
