import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Models/NotificationModel.dart';
import '../../../Providers/Tables.dart';

class TablesNotificationWidget extends StatefulWidget {
  TablesNotificationWidget({Key? key, required this.tableID}) : super(key: key);
  final int tableID;
  @override
  State<TablesNotificationWidget> createState() => _TablesNotificationWidgetState();
}

class _TablesNotificationWidgetState extends State<TablesNotificationWidget> {

  @override
  Widget build(BuildContext context) {
    var tableprov = Provider.of<Tables>(context, listen: true);
    var singleTable = tableprov.items.firstWhere((element) => element.id == widget.tableID);
    List<NotificationModel> notifications = singleTable.notifications;
    return notifications.isEmpty ? Container(width: 50,) : GestureDetector(
      onTapUp: (e){
        final _scrollController = ScrollController();
        var alert = StatefulBuilder(
          builder: (context, setState) {
            if(notifications.isEmpty) {
              Future.delayed(const Duration(milliseconds: 100)).then((value) {
                Navigator.pop(context);
              });
              return Container();}
            return AlertDialog(
              actions: [
                ElevatedButton(
                    child: const Text('Okay'), onPressed: () => {Navigator.of(context).pop()})
              ],
          title: const Text("Notifications"),
          content: Scrollbar(
              interactive: true,
              thickness: 5,
              controller: _scrollController,
              child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: SingleChildScrollView(
                    //physics: const NeverScrollableScrollPhysics(),
                      controller: _scrollController,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children:
                            notifications.map((e) =>
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(e.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                                    const SizedBox(height: 5,),
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(28),
                                        ),
                                        child: Text(e.msg, style: TextStyle(fontSize: 18),),
                                    ),
                                    const SizedBox(height: 5,),
                                    GestureDetector(
                                      onTapUp: (l){
                                        setState((){
                                          for(int x = 0; x < notifications.length; x++){
                                            if(notifications[x].id == e.id){
                                              singleTable.notifications.removeAt(x);
                                              tableprov.notifyListeners();
                                              return;
                                            }
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFDDDDDD),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Text("löschen", style: TextStyle(fontSize: 18, color: Colors.red),),
                                      ),
                                    ),
                                    const SizedBox(height: 15,),
                                  ],
                                ),
                              )
                            ).toList(),
                      )
                  )
              )
          ),
        );
          });
        // show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      },
      child: Stack(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 5,),
              Container(
                width: 50,
                height: 50,
                //padding: const EdgeInsets.all(8),
                //child: Icon(),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .primaryColorDark
                          .withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset:
                      const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  color: const Color(0xFFEEEEEE),//Theme.of(context).primaryColorDark,

                  // color: Colors.white,
                  // boxShadow: [
                  //   const BoxShadow(color: Colors.green, spreadRadius: 3),
                  // ],
                ),
                child: notifications[0].imagePath != null ?
                    Image.network(
                      notifications[0].imagePath!,
                      fit: BoxFit.fill,
                ) : Container(),
              ),
              const SizedBox(width: 15,),
            ],
          ),
          Positioned(
              right: 0,
              top: 0,
              child:
              notifications.length > 1
                  ? Text( "+" +
                  (notifications.length-1).toString(),
                style: const TextStyle(fontSize: 18),
              ) : Container()
          ),
        ],
      ),
    );
  }
}
