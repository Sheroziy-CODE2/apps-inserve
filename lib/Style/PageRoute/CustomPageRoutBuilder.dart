
import 'package:flutter/material.dart';

class CustomPageRouteBuilder<T> extends PageRoute<T> {
  final RoutePageBuilder pageBuilder;
  final PageTransitionsBuilder matchingBuilder = const CupertinoPageTransitionsBuilder(); // Default iOS/macOS (to get the swipe right to go back gesture)
  // final PageTransitionsBuilder matchingBuilder = const FadeUpwardsPageTransitionsBuilder(); // Default Android/Linux/Windows

  CustomPageRouteBuilder({required this.pageBuilder});

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return pageBuilder(context, animation, secondaryAnimation);
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 600); // Can give custom Duration, unlike in MaterialPageRoute

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return matchingBuilder.buildTransitions<T>(this, context, animation, secondaryAnimation, child);
  }
}