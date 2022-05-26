import 'package:flutter/material.dart';
import 'package:inspery_pos/Providers/SideProducts.dart';
import 'package:provider/provider.dart';

import 'Providers/TableItemChangeProvidor.dart';
import 'Providers/TableItemProvidor.dart';
import 'Providers/TableItemsProvidor.dart';
import 'screens/TablesViewScreen.dart';
import 'screens/TableViewScreen.dart';

//providers
import './Providers/Tables.dart';
import 'Providers/Authy.dart';
import 'Providers/Categorys.dart';
import 'Providers/Products.dart';
import 'Providers/Ingredients.dart';
import './Providers/Authy.dart';

//screens
import 'package:inspery_pos/screens/SignInScreen.dart';
import 'screens/SplashScreen.dart';
import 'screens/InvoicesViewScreen.dart';
import 'screens/InvoiceViewScreen.dart';
import 'screens/HomePageScreen.dart';
import 'screens/ProvidersApiCallsScreen.dart';
import 'screens/ProfileScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navKey = GlobalKey();
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // create all of teh provider will be used in the app
        ChangeNotifierProvider(
          create: (ctx) => Authy(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SideProducts(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Tables(),
        ),
        // ChangeNotifierProvider(
        //   create: (ctx) => Prices(),
        // ),
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => TableItemChangeProvidor(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Ingredients(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Categorys(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => TableItemProvidor(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => TableItemsProvidor(),
        ),
      ],
      child: Consumer<Authy>(
        builder: (ctx, auth, _) => MaterialApp(
          navigatorKey: navKey,
            title: 'Flutter Demo',
            theme: ThemeData(
              // the colors and font
              primaryColorDark: Color(0xFF2C3333),
              cardColor: Color(0xFFF5F2E7),
              fontFamily: 'Quicksand',
            ),
            home: auth.isAuth
                ? ProvidersApiCalls()
                : FutureBuilder(
                    //this future builder will check if we have a token or not
                    //if we have one it will log in automaticlly
                    future: auth.tryAutoLogIn(),
                    builder: (ctx, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : const SignIn()),
            routes: {
              // all of the raoutes in the app
              HomePage.routeName: (ctx) => const HomePage(),
              TablesView.routeName: (ctx) => TablesView(),
              TableView.routeName: (ctx) => TableView(),
              InvoicesView.routeName: (ctx) => InvoicesView(),
              InvoiceView.routeName: (ctx) => InvoiceView(),
              ProvidersApiCalls.routeName: (ctx) => ProvidersApiCalls(),
              Profile.routeName: (ctx) => Profile(),
              SignIn.routeName: (ctx) => SignIn(),
            }),
      ),
    );
  }
}
