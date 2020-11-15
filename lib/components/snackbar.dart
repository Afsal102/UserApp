import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBars {
  void showSnackBar(String name, var screen) {
    dispose();
    Get.snackbar('Oops! Seems Like you are ${name.toUpperCase()}!!',
        'Some Thing Went Wrong',
        snackPosition: SnackPosition.TOP,
        barBlur: 50,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: 40, left: 15, right: 15),
        colorText: Colors.white,
        duration: Duration(seconds: 10),
        snackStyle: SnackStyle.FLOATING,
        animationDuration: Duration(seconds: 15), onTap: (snack) {
      screen ?? print('noscreent');
    },
        dismissDirection: SnackDismissDirection.VERTICAL,
        backgroundColor: Colors.blueGrey[900]);
  }

  void dispose() {
    if (Get.isSnackbarOpen) Get.back();
  }
}
