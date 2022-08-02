import 'package:provider/provider.dart';
import '../Models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Providers/Authy.dart';
import 'ProvidersApiCallsScreen.dart';

class EmailFieldValidator {
  static String? validate(String value) {
    return value.isEmpty ? "Email should not be empty" : null;
  }
}

class PasswordFieldValidator {
  static String? validate(String value) {
    return value.isEmpty ? "Password should not be empty" : null;
  }
}

class SignIn extends StatefulWidget {
  static const routeName = '/sign-in';

  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  List<double> widgetPositions = [0.20, 0.4, 0.65, 0.85];

  final userController = TextEditingController();
  final pwController = TextEditingController();

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
          title: const Text('es gibt ein Fehler'),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
                child: const Text('Okay'), onPressed: () => {Navigator.of(ctx).pop()})
          ]),
    );
  }

  Future<void> _submit(String user, String pw) async {
    try {
      // try to login
      await Provider.of<Authy>(context, listen: false).signIn(user, pw);
      Navigator.of(context).pushReplacementNamed(
        ProvidersApiCalls.routeName,
      );
    } on HttpException catch (error) {
      _showError(error.toString());
    } catch (error) {
      _showError(error.toString());
      //var errorMessage = "Fehler bitte versuchen Sie später.";
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor, //Colors.transparent,
      body: ListView(
        children: [
          SizedBox(
            height: screenHight * widgetPositions[0],
          ),
          Row(
            children: [
              const Spacer(),
              retDot(),
              retDot(),
              retDot(),
              retDot(),
              retDot(),
              retDot(),
              retDot(),
              const Spacer(),
            ],
          ),
          SvgPicture.asset(
            'assets/illustrations/inspery.svg',
            matchTextDirection: true,
          ),
          const Center(
            child: Text(
              'I N S P E R Y',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Color(0xFF2C3333),
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(
            height: 70,
          ),
          Center(
            child: SizedBox(
              width: 246,
              height: 43,
              child: TextField(
                controller: userController,
                key: const Key("username_data"),
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                keyboardType:
                    TextInputType.emailAddress, //TODO: Check if Name or Email
                style: const TextStyle(fontSize: 20, color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Username",
                  hintStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  alignLabelWithHint: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).cardColor,
                    ),
                  ),
                  fillColor: Theme.of(context).primaryColorDark,
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  floatingLabelStyle: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).cardColor,
                  ),
                  labelStyle: TextStyle(
                      fontSize: 18, color: Theme.of(context).cardColor),
                  focusColor: Theme.of(context).primaryColorDark,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: SizedBox(
              width: 246,
              height: 43,
              child: TextField(
                controller: pwController,
                key: const Key("password_data"),
                textAlign: TextAlign.center,
                obscureText: true,
                textAlignVertical: TextAlignVertical.center,
                keyboardType:
                    TextInputType.emailAddress, //TODO: Check if Name or Email
                style: const TextStyle(fontSize: 20, color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  alignLabelWithHint: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  fillColor: Theme.of(context).primaryColorDark,
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  floatingLabelStyle: TextStyle(
                      fontSize: 20, color: Theme.of(context).cardColor),
                  labelStyle: TextStyle(
                      fontSize: 18, color: Theme.of(context).cardColor),
                  focusColor: Theme.of(context).cardColor,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: GestureDetector(
              child: Container(
                width: 151,
                height: 26,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    key: Key("login_button"),
                  ),
                ),
              ),
              onTap: () {
                _submit(userController.text, pwController.text);
              },
            ),
          ),
          const SizedBox(
            height: 110,
          ),
          SvgPicture.asset(
            'assets/illustrations/inspery.svg',
            matchTextDirection: true,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

Widget retDot() {
  return Padding(
    padding: const EdgeInsets.all(3),
    child: Container(
      // Use the properties stored in the State class.
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment
              .bottomCenter, // 10% of the width, so there are ten blinds.
          colors: <Color>[
            Color(0xFF2C3333),
            Color.fromARGB(0, 255, 255, 255)
          ], // red to yellow
          tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
