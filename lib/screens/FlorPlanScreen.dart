import 'package:flutter/material.dart';
import 'package:inspery_waiter/Providers/FlorLayoutProvider.dart';
import 'package:inspery_waiter/screens/HomePageScreen.dart';
import 'package:inspery_waiter/widgets/florPlan/SingleFlorWidget.dart';
import 'package:provider/provider.dart';

import '../Style/PageRoute/CustomPageRoutBuilder.dart';

class FlorPlanScreen extends StatefulWidget {
  static const routeName = '/flor-plan';
  const FlorPlanScreen({Key? key}) : super(key: key);

  @override
  State<FlorPlanScreen> createState() => _FlorPlanScreenState();
}

class _FlorPlanScreenState extends State<FlorPlanScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> animation;
  int? selectedFloor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    ); // <-- Set your duration here.
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    animation = Tween<double>(begin:0, end:  1).animate(_controller);

    final florProv = Provider.of<FlorLayoutProvider>(context, listen: false);
    florProv.generateFlors(numberOfFlors: 3, context: context);
    final double screenheight = MediaQuery.of(context).size.height-121;
    final double screenwidth = MediaQuery.of(context).size.width;
    final double florSizeX = florProv.highestX();
    final double florSizeY = florProv.highestY();
    final double drawnFlorSizeX = screenwidth*0.5;
    final double drawnFlorSizeY = (screenwidth*0.5*(florSizeX/florSizeY));


    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body:
      SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 4,
                    offset: Offset(0, 5), // Shadow position
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        CustomPageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const HomePage()),
                      );
                    },
                    child: const SizedBox(
                      width: 50,
                      child: Center(
                        child: Icon(Icons.arrow_back_ios, color: Color(0xFF2C3333),),
                      ),
                    ),
                  ),
                  Text((selectedFloor != null? "Flor: " + selectedFloor.toString() : "Wähle eine Etage"), style: const TextStyle(fontSize: 20),),
                  const SizedBox(width: 50,),
                ],
              ),
            ),
            InteractiveViewer(
              child: AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, Widget? child) {
                    final double rotation = -0.8*(1-animation.value);
                    final double scale = 1+animation.value;
                    List<bool> showWidgets = List.generate(florProv.items.length, (index) => true);
                    if(selectedFloor != null && animation.value == 0){
                      showWidgets = List.generate(florProv.items.length, (index) => false);
                      showWidgets[selectedFloor!] = true;
                    }

                    return SizedBox(
                      width: screenwidth,
                      height: screenheight,
                      child: Stack(
                        alignment: Alignment.center,
                        children: List.generate(florProv.items.length, (index) =>
                        showWidgets[index] ? Positioned(
                          top: screenheight*0.3 - ((screenheight/9)*index)*(1-animation.value),
                          child: Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.005)
                              ..rotateX(rotation)
                              ..scale(scale)
                            ,
                            alignment: FractionalOffset.center,
                            child:
                            Stack(
                              children: [
                                Opacity(
                                    opacity: selectedFloor == null ? 1 : selectedFloor == index ? 1 : (1-animation.value),

                                    child: SingleFlorWidget(drawnFlorSizeX: drawnFlorSizeX, drawnFlorSizeY: drawnFlorSizeY, florNumber: index,)
                                ),
                                animation.value != 1 ? Positioned.fill(child: GestureDetector(
                                  onTap: animation.value != 0 ? null : ((){
                                    setState((){
                                      selectedFloor = index;
                                      _controller.forward();
                                    });
                                  }),
                                )): Container(),
                              ],
                            ),

                          ),
                        ): Container(),
                        ).toList(),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
