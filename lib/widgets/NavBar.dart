import 'package:flutter/material.dart';
import '../Style/Icons/inspery_icons_icons.dart';
import '../screens/TablesViewScreen.dart';
import '../screens/InvoicesViewScreen.dart';
import '../screens/HomePageScreen.dart';
import '../screens/ProfileScreen.dart';

class NavBar extends StatefulWidget {
  final int selectedIcon;
  const NavBar({Key? key, required this.selectedIcon}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      color: Theme.of(context).cardColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: [
              Text (widget.selectedIcon == 1 ? "Eingabe" : " ", style: TextStyle(fontSize: 13, height: 1.7, letterSpacing: 1, fontWeight: FontWeight.bold, color: widget.selectedIcon == 1 ? Colors.red : Colors.black)),
              IconButton(
                icon: Icon(InsperyIcons.icons8_ten_keys_48, size: 30, color: widget.selectedIcon == 1 ? Colors.red : Colors.black),
                key: const Key("mainPage"),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(HomePage.routeName);
                },
              ),
            ],
          ),
          Column(
            children: [
              Text (widget.selectedIcon == 2 ? "Tische" : " ", style: TextStyle(fontSize: 13, height: 1.7, letterSpacing: 1, fontWeight: FontWeight.bold, color: widget.selectedIcon == 2 ? Colors.red : Colors.black)),
              IconButton(
                icon: Icon(InsperyIcons.icons8_chair_32, size: 30, color: widget.selectedIcon == 2 ? Colors.red : Colors.black),
                key: const Key("tablePage"),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(TablesView.routeName);
                },
              ),
            ],
          ),
          Column(
            children: [
              Text (widget.selectedIcon == 3 ? "Rechnungen": " ", style: TextStyle(fontSize: 13, height: 1.7, letterSpacing: 1, fontWeight: FontWeight.bold, color: widget.selectedIcon == 3 ? Colors.red : Colors.black)),
              IconButton(
                icon: Icon(InsperyIcons.icons8_insert_money_euro_50, size: 30, color: widget.selectedIcon == 3 ? Colors.red : Colors.black),
                key: const Key("invoicePage"),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(InvoicesView.routeName);
                },
              ),
            ],
          ),
          Column(
            children: [
              Text (widget.selectedIcon == 4 ? "Profil" : " ", style: TextStyle(fontSize: 13, height: 1.7, letterSpacing: 1, fontWeight: FontWeight.bold, color: widget.selectedIcon == 4 ? Colors.red : Colors.black)),
              IconButton(
                icon: Icon(Icons.person_sharp, size: 30, color: widget.selectedIcon == 4 ? Colors.red : Colors.black),
                key: const Key("profilePage"),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(Profile.routeName);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
