import 'package:flutter/material.dart';
import 'package:inspery_waiter/screens/FlorPlanScreen.dart';
import 'package:provider/provider.dart';
import '../Providers/Tables.dart';
import '../widgets/Buttons.dart';
import '../widgets/NavBar.dart';
import 'TableViewScreen.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home-page';
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const snackBarTable = SnackBar(
    content: Text('Such Table doesnt exist'),
  );
  var userText = "";

  final List<String> buttons = [
    "7", "8", "9", " ",
    "4", "5", "6", " ",
    "1", "2", "3", " ",
    "0", ".", "DEL", "Tisch",
  ];

  @override
  Widget build(BuildContext context) {
    final tablesData = Provider.of<Tables>(context);
    var id = tablesData.findByName(userText).id;
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      bottomNavigationBar: const NavBar(selectedIcon: 1),
      body: Column(
        children: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints(),
            child: Container(
              child: Column(
                  children: <Widget>[
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          padding: const EdgeInsets.only(right: 15),
                          icon: const Icon(Icons.layers, size: 28,color: Color(0xFF7B7B7B),),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(FlorPlanScreen.routeName);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.centerRight,
                      child: userText.isEmpty ? const Text('Tisch', maxLines: 1, style: TextStyle(fontSize: 50))
                      : Text(userText, maxLines: 1, style: const TextStyle(fontSize: 50)),
                    ),
                  ]),
            ),
          ),
          const Spacer(),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 405),
            child: Container(
              color: Theme.of(context).cardColor, //Colors.grey[350],
              child: Center(
                child: GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: buttons.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                    itemBuilder: (BuildContext context, int index) {
                      //Tisch button
                      if (index == 15) {
                        return MyButton(
                          buttonTapped: () {
                            if (id != 0) {
                              Navigator.of(context).pushReplacementNamed(
                                TableView.routeName,
                                arguments: id.toString(),
                              );
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBarTable);
                            }
                          },
                          buttonText: buttons[index],
                          color: const Color.fromARGB(255, 28, 114, 33),
                          textColor: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(15)
                        );
                      }
                      // DEL button
                      else if (index == 14) {
                        return MyButton(
                          buttonTapped: () {
                            setState(() {
                              userText = "";
                            });
                          },
                            buttonText: buttons[index],
                            color: const Color.fromARGB(255, 165, 39, 30),
                            textColor: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(15),
                        );
                      }
                      // Empty Buttons
                      else if (index == 3 || index == 7 || index == 11) {
                        return MyButton(
                            buttonText: buttons[index],
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(15)
                        );
                      } else {
                        return MyButton(
                          buttonTapped: () {
                            setState(() {
                              userText += buttons[index];
                            });
                          },
                          buttonText: buttons[index],
                          color: Theme.of(context).primaryColorDark,
                          textColor: buttons[index] == " "
                              ? Theme.of(context).primaryColorDark
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(15),
                        );
                      }
                    }),
              ),
            ),
          ),
          const SizedBox(height: 20,),
        ],
      ),
      //to use navigation bar in the page, it needs to be called with NavBar class
    );
  }
}
