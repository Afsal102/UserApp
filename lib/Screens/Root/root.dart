import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groceryuser/Controller/cart_controller.dart';
import 'package:groceryuser/Controller/root_cntroller.dart';
import 'package:groceryuser/Screens/Home/home.dart';
import 'package:groceryuser/Screens/Orders/orders.dart';
import 'package:groceryuser/Screens/Profile/profile.dart';
import 'package:groceryuser/Screens/Search/search.dart';

class Root extends StatelessWidget {
  final List<Widget> _cureentPage = [Home(), Search(), Orders(), Profile()];
  final rootController =
      Get.lazyPut<RootNavController>(() => RootNavController());
  final cartController = Get.lazyPut<CartController>(() => CartController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: GetX<RootNavController>(
        builder: (controller) {
          return BottomNavigationBar(
            showSelectedLabels: false,
            elevation: 10.0,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            iconSize: 23,
            currentIndex: controller.currentIndex.value,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.blue,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'search',
                backgroundColor: Colors.blue,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Orders',
                backgroundColor: Colors.blue,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: Colors.blue,
              ),
            ],
            onTap: (value) {
              controller.currentIndex.value = value;
            },
          );
        },
      ),
      body: GetX<RootNavController>(
        builder: (conrollr) {
          return IndexedStack(
            index: conrollr.currentIndex.value,
            children: _cureentPage,
          );
        },
      ),
    );
  }
}
