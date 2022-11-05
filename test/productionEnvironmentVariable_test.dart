import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env.production");
  });

  test('Correct develop API_URL should be excepted', () {
    var apiURL = dotenv.env['API_URL'];
    expect(apiURL, "https://production.inspery.com/");
  });

  test('Wrong develop API_URL should be rejected', () {
    var apiURL = dotenv.env['API_URL'];
    expect(apiURL != "https://inspery.com/", isTrue);
  });

}