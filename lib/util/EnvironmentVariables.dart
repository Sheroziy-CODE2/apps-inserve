


import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentVariables{

  static String get fileName => kReleaseMode ? ".env.development" : ".env.development"; //change later first condition to .env.production
  static String get apiUrl => dotenv.env['API_URL'] ?? 'MY_FALLBACK';

  static const file = '.env.development';
  Map<String, String> environment_variables = {};

  Future load({String assetsFileName = file}) async {
    final lines = await rootBundle.loadString(assetsFileName);
    Map<String, String> environment = {};
    for (String line in lines.split('\n')) {
      line = line.trim();
      if (line.contains('=') //Set Key Value Pairs on lines separated by =
          &&
          !line.startsWith(RegExp(r'=|#'))) {
        //No need to add emty keys and remove comments
        List<String> contents = line.split('=');
        environment[contents[0]] = contents.sublist(1).join('=');
      }
    }
    environment_variables = environment;
  }

  Future<String?> getQRPath({required int tableID, required String tableKey}) async {
    if(environment_variables.isEmpty) {
      await load();
    }
    if(!environment_variables.containsKey("URL_QRCODE_APP")) {
      return null;
    }
    return environment_variables["URL_QRCODE_APP"]! + tableID.toString() + "/" + tableKey;
  }

}