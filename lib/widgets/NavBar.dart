import 'package:flutter/material.dart';
import '../Style/Icons/inspery_icons_icons.dart';
import '../Style/PageRoute/CustomPageRoutBuilder.dart';
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

    Widget singelItem({required int selected, required String name, required IconData icon, required routingName, required key}) {
      return Center(
        child:
        widget.selectedIcon == selected ? Text(name,
            style: TextStyle(
                fontSize: 14,
                height: 1.7,
                letterSpacing: 1,
                fontWeight: FontWeight.bold,
                color: widget.selectedIcon == selected ? const Color(0xFFE08A3A) : Colors.black)) :
        IconButton(
          icon: Icon(icon, size: 30,
              color: widget.selectedIcon == selected ? const Color(0xFFE08A3A) : Colors.black),
          key: Key(key),
          onPressed: () {
            Navigator.push(
              context,
              CustomPageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => routingName),
            );
          },
        ),
      );
    }

    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 4,
            offset: Offset(0, -5), // Shadow position
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          singelItem(name: "Eingabe", selected: 1, icon: InsperyIcons.icons8_ten_keys_48, routingName: HomePage(), key: "mainPage"),
          singelItem(name: "Tische", selected: 2, icon: InsperyIcons.icons8_chair_32, routingName: TablesView(), key: "tablePage"),
          singelItem(name: "Rechnungen", selected: 3, icon: InsperyIcons.icons8_insert_money_euro_50, routingName: InvoicesView(), key: "invoicePage"),
          singelItem(name: "Profil", selected: 4, icon: Icons.person_sharp, routingName: Profile(), key: "profilePage"),
        ],
      ),
    );
  }
}
