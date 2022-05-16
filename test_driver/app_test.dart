import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Checking the login page and home page', () {
     late FlutterDriver driver;

    // Connection to the Flutter driver.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });


    // Closing connection after completetion the test.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test("check health", () async {
      Health health = await driver.checkHealth();
      print(health.status);
    });

    final userField = find.byValueKey("username_data");
    final passField = find.byValueKey("password_data");
    final logInButton = find.byValueKey("login_button");

    final mainPageFinder = find.byValueKey("mainPage");

     test('Should start with counter empty ', () async {
       await driver.tap(userField);
       await driver.enterText('omar');
       await driver.waitFor(find.text('omar'));

       await driver.tap(passField);
       await driver.enterText('bigsur99');
       await driver.waitFor(find.text('omar'));

       await driver.tap(logInButton);


       await driver.tap(mainPageFinder);
       //expect(await driver.getText(readDataFinder), " ");
     });
     /*
     test('Should increase counter by 1', () async {
       await driver.tap(writeDataFinder);
       expect(await driver.getText(readDataFinder), "7");
     });

      */
  });
}