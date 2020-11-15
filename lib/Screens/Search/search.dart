import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groceryuser/Controller/cart_controller.dart';

import 'package:groceryuser/Controller/loginController.dart';
import 'package:groceryuser/Screens/Cart/cart_pg.dart';
import 'package:logger/logger.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class Search extends StatelessWidget {
  final logger = Logger();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            IconButton(
              icon: Icon(OMIcons.favorite),
              padding: EdgeInsets.zero,
              onPressed: () async {
                Get.to(CartPage());
              },
            ),
            FlatButton(
                onPressed: () {
                  // Logger().i(Get.find<CartController>().finallsall.value);
                },
                child: Text('Hello'))
          ],
        ),
      ),
    );
  }
}

class Afzal {
  String name;
  Afzal({
    this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
