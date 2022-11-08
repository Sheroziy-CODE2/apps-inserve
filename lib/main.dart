import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:inspery_waiter/Providers/FlorLayoutProvider.dart';
import 'package:inspery_waiter/screens/FlorPlanScreen.dart';
import 'package:inspery_waiter/util/EnvironmentVariables.dart';
import '/screens/SignInScreen.dart';
import 'package:provider/provider.dart';

import 'Providers/NotificationProvider.dart';
import 'Providers/TableItemChangeProvidor.dart';
import 'Providers/TableItemProvidor.dart';
import 'Providers/TableItemsProvidor.dart';
import 'Providers/WorkersProvider.dart';
import 'screens/TablesViewScreen.dart';
import 'screens/TableViewScreen.dart';

//providers
import './Providers/Tables.dart';
import 'Providers/Authy.dart';
import 'Providers/Categorys.dart';
import 'Providers/Products.dart';
import 'Providers/Ingredients.dart';

//screens
import 'screens/SplashScreen.dart';
import 'screens/InvoicesViewScreen.dart';
import 'screens/InvoiceViewScreen.dart';
import 'screens/HomePageScreen.dart';
import 'screens/ProvidersApiCallsScreen.dart';
import 'screens/ProfileScreen.dart';

Future<void> main() async {
  // Step 2
  WidgetsFlutterBinding.ensureInitialized();
  // Step 3
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(
      Phoenix(
        child: MyApp(),
      )
  ));
  //Load Needed URL FOR ENVIRONMENT
  await dotenv.load(fileName: EnvironmentVariables.fileName);

  runApp(
      Phoenix(
        child: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navKey = GlobalKey();
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return MultiProvider(
      providers: [
        // create all of teh provider will be used in the app
        ChangeNotifierProvider(
          create: (ctx) => Authy(),
        ),
        // ChangeNotifierProvider(
        //   create: (ctx) => SideProducts(),
        // ),
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
        ChangeNotifierProvider(
          create: (ctx) => WorkersProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => FlorLayoutProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => NotificationProvider(),
        ),
      ],
      child: Consumer<Authy>(
        builder: (ctx, auth, _) => InAppNotification(
          child: MaterialApp(
              navigatorKey: navKey,
              title: 'InServe',
              theme: ThemeData(
                pageTransitionsTheme: const PageTransitionsTheme(builders: {
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                }),
                // the colors and font
                primaryColorDark: const Color(0xFF2C3333),
                cardColor: const Color(0xFFF5F2E7),
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
                              ? const SplashScreen()
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
                FlorPlanScreen.routeName: (ctx) => FlorPlanScreen(),
              }),
        ),
      ),
    );
  }
}
