import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groceryuser/Controller/loginController.dart';
import 'package:groceryuser/Screens/Login/components/body.dart';
import 'package:groceryuser/components/loading.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<LoginConroller>(
        init: LoginConroller(),
        builder: (controller) {
          if (controller.loginShowLoading.value == true) {
            return Loading();
          }
          return Body();
        },
      ),
    );
  }
}
