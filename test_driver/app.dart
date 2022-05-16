import 'package:flutter_driver/driver_extension.dart';
import 'package:inspery_pos/main.dart' as insperyTest;
void main() {

  //Enable flutter driver to allow interaction with the app
  enableFlutterDriverExtension();

  //Start our main app from the main lib package
  insperyTest.main();
}