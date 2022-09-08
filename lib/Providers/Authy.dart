import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';

class Authy extends ChangeNotifier {
  String? _token;
  String? email;
  String? first_name;
  String? last_name;
  String? profile_info;
  String? created;
  bool? is_email_verified;
  List<UserGroupModel> groups = [];
  late int _id;
  String _userName = '';
  static final _storage = FlutterSecureStorage();
  static const _keyUserName = 'username';
  static const _keyPassword = 'password';
  late String photoLink = "";
  String RestaurantPhotoLink = "";

  String getUserName(){
    String name = "";
    if(first_name != null){
      name += first_name!;
    }
    if(last_name != null){
      name += " " + last_name!;
    }
    if(name == ""){
      name = _userName;
    }
    return name;
  }

  Future<void> getRestaurantPhoto() async {
    //callling the restaurant info Api
    final url = Uri.parse('https://www.inspery.com/app/api/restaurant/3');
    try {
      final response = await http.get(url);
      var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
      RestaurantPhotoLink = jsonResponse[0]['logo'];
    } catch (e) {
      print('error : ${e}, getRestaurant API');
    }

    //comment out the next two lines to prevent the device from getting
    // the image from the web in order to prove that the picture is
    // coming from the device instead of the web.
    //var photoUrl = RestaurantPhotoLink; // <-- 1
    var response = await get(url); // <--2
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + "/images";
    var filePathAndName = documentDirectory.path + '/images/pic.jpg';
    //comment out the next three lines to prevent the image from being saved
    //to the device to show that it's coming from the internet
    await Directory(firstPath).create(recursive: true); // <-- 1
    File file2 = File(filePathAndName); // <-- 2
    file2.writeAsBytesSync(response.bodyBytes); // <-- 3
    RestaurantPhotoLink = filePathAndName;
  }

  static Future setUsername(String username) async {
    //to save the username safly
    await _storage.write(key: _keyUserName, value: username);
  }

  static Future setPassword(String password) async {
    //to save the password safly
    await _storage.write(key: _keyPassword, value: password);
  }

  Future<String?> getUsername() async =>
      // to get the userName
      await _storage.read(key: _keyUserName);

  static Future<String?> getPassword() async =>
      // to get the Password
      await _storage.read(key: _keyPassword);

  bool get isAuth {
    // will verify if the user is loged in
    return (_token != null);
  }

  String get token {
    // will give the token back if the user is loged in
    if (_token != '') {
      return '$_token';
    }
    return '';
  }

  String get userName {
    // will give the username
    return _userName;
  }

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> tryAutoLogIn() async {
    // this function will try to log in if there is any data stored in the SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final m = prefs.getString('userData') ?? '';
    if (m != '') {
      final userData = json.decode(m) as Map<String, dynamic>;
      // if there is not token return false
      if (userData['password'] == null) {
        return false;
      }
      if (m == '') {
        return false;
      }
      // else set the token and return true
      if (userData['password'] != null) {
        await signIn(userData['userName'], userData['password']);
        return true;
      }
      notifyListeners();
    }

    return false;
  }

  Future<void> signIn(String userName, String passWord) async {
    // this function will call the login API and save the data in SharedPreferences
    final url = Uri.parse(
      'https://www.inspery.com/authy/login',
    );
    final headers = {"Content-type": "application/json"};
    final json = {"username": userName, "password": passWord};
    final m = jsonEncode(json);
    try {
      final response = await http.post(url, headers: headers, body: m);
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      // throw an error
      if (jsonResponse.keys.contains('non_field_errors')) {
        throw HttpException(jsonResponse['non_field_errors'][0]);
      } else {
        // add the user if the info are correct
        setUsername(jsonResponse["user"]["username"]);
        setPassword(passWord);
        _id = jsonResponse["user"]["id"];
        _userName = jsonResponse["user"]["username"];
        print(jsonResponse["user"]["groups"].length);
        groups = jsonResponse["user"]["groups"] == null ? [] : List.generate(jsonResponse["user"]["groups"].length, (index) =>
            UserGroupModel(id: jsonResponse["user"]["groups"][index]["id"],name: jsonResponse["user"]["groups"][index]["name"]));
        is_email_verified = jsonResponse["user"]["profile"]["is_email_verified"];
        first_name = jsonResponse["user"]["profile"]["first_name"];
        last_name = jsonResponse["user"]["profile"]["last_name"];
        created = jsonResponse["user"]["profile"]["created"];
        email = jsonResponse["user"]["email"];
        profile_info = jsonResponse["user"]["profile"]["profile_info"];
        photoLink = jsonResponse["user"]["profile"]["picture"] ?? '';
        _token = jsonResponse["token"];
      }
    } catch (error) {
      throw error;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    var data = {};
    data['token'] = _token;
    data['id'] = _id;
    data['userName'] = await getUsername();
    data['password'] = await getPassword();

    String userData = jsonEncode(data);
    prefs.setString('userData', userData);

    getRestaurantPhoto();
  }
}

class UserGroupModel{
  int id;
  String name;

  UserGroupModel({
    required this.id,
    required this.name,
  });
}