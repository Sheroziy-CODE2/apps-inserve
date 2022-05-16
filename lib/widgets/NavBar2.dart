import 'package:flutter/material.dart';
import 'package:inspery_pos/Style/Icons/inspery_icons_icons.dart';
import '../screens/InvoicesViewScreen.dart';
import '../screens/HomePageScreen.dart';
import '../screens/ProfileScreen.dart';
import '../screens/TablesViewScreen.dart';


//THESE Navigation is not used for now, as it requires refactoring of CODE in other places.

class NavBar2 extends StatefulWidget {
  const NavBar2({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar2> {
  int _selectedIndex = 0;

  List<Widget> _screenOptions = <Widget>[
    HomePage(),
    TablesView(),
    InvoicesView(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screenOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).cardColor,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.red,
        selectedIconTheme: IconThemeData(color: Colors.red, size: 30),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        iconSize: 25,
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(InsperyIcons.icons8_ten_keys_48),
            label: 'Eingabe',
          ),
          BottomNavigationBarItem(
            icon: Icon(InsperyIcons.icons8_chair_32),
            label: 'Tische',
          ),
          BottomNavigationBarItem(
            icon: Icon(InsperyIcons.icons8_insert_money_euro_50),
            label: 'Rechnungen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_sharp),
            label: 'Profil',
          ),
        ],
        onTap: (index){
          setState(() {
            _selectedIndex = index;
          });
        },
      )
    );
  }
}
