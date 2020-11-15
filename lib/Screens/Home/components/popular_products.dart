import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groceryuser/Controller/product_controller.dart';
import 'package:groceryuser/components/productItems.dart';

class PopularProducts extends StatelessWidget {
  final prodsController = Get.find<ProductController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GetX<ProductController>(
        builder: (controller) {
          if (controller != null && controller.prods.length != 0) {
            return ListView.builder(
              itemCount: controller.prods.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return ProductItems();
              },
            );
          }
          return Offstage(offstage: true,);
        },
        
      ),
    );
  }
}
