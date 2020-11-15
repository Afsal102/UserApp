import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groceryuser/Controller/bindings/auth_binding.dart';
import 'package:groceryuser/Controller/loginController.dart';
import 'package:groceryuser/Screens/Root/root.dart';
import 'package:groceryuser/Screens/Welcome/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(UserApp());
}

class UserApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
      initialBinding: AuthBinding(),
    );
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<LoginConroller>(
      init: LoginConroller(),
      builder: (controller) {
        if (controller != null) {
          if (controller.user != null) {
            return Root();
          } else {
            return WelcomeScreen();
          }
        }
        return WelcomeScreen();
      },
    );
  }
}
