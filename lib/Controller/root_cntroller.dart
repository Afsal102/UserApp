import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RootNavController extends GetxController{
  var currentIndex = 0.obs;

  @override
  void onInit() {
    currentIndex.value = 0;
   
    super.onInit();
  }

}