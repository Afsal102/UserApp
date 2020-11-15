import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groceryuser/Controller/loginController.dart';
import 'package:groceryuser/Screens/Signup/components/body.dart';
import 'package:groceryuser/components/loading.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<LoginConroller>(
        init: LoginConroller(),
        
        builder: (controller) {
          if(controller!=null){
            return controller.showLoading.value==true?Loading():Body();
          }
          return Body();
        },
      ),
    );
  }
}
