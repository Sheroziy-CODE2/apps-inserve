import 'package:flutter/material.dart';
import 'package:inspery_waiter/Providers/FlorLayoutProvider.dart';
import 'package:inspery_waiter/screens/HomePageScreen.dart';
import 'package:inspery_waiter/widgets/florPlan/SingleFlorWidget.dart';
import 'package:provider/provider.dart';

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
 //late List<GlobalObjectKey<SingleFlorWidgetState>> globalKeys;

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
    final double screenheight = MediaQuery.of(context).size.height-120;
    final double screenwidth = MediaQuery.of(context).size.width;
    final double florSizeX = florProv.highestX();
    final double florSizeY = florProv.highestY();
    final double drawnFlorSizeX = screenwidth*0.5;
    final double drawnFlorSizeY = (screenwidth*0.5*(florSizeX/florSizeY));
    //globalKeys = List.generate(florProv.items.length, (index) => GlobalObjectKey(987654321 + index));


    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40,),
          Row(
            children: [
              GestureDetector(
                  onTap: ((){
                    Navigator.of(context).pushReplacementNamed(HomePage.routeName);
                  }),
                  child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.arrow_back_ios))),
              const Spacer(),
              Text((selectedFloor != null? "Flor: " + selectedFloor.toString() : "Wähle eine Etage"), style: const TextStyle(fontSize: 20),),
              const Spacer(),
              const SizedBox(width: 30,),
            ],
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
                    //globalKeys[selectedFloor!].currentState!.setNewHight(newHight: screenheight);
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
    );
  }
}
