import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groceryuser/Controller/cart_controller.dart';
import 'package:groceryuser/Models/cart_model.dart';
import 'package:groceryuser/Models/productmodel.dart';
import 'package:groceryuser/Screens/SingleProducts/singleproductspage.dart';
import 'package:groceryuser/components/loading.dart';
import 'package:logger/logger.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class CartPage extends StatelessWidget {
  final cartController = Get.find<CartController>();
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: GoogleFonts.raleway(),
      child: Scaffold(
        bottomNavigationBar: bottomAppbar(cartController),
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text('My Cart'),
          leading: IconButton(
            icon: Icon(OMIcons.chevronLeft),
            onPressed: () {
              Get.back();
            },
          ),
          elevation: 0.0,
          automaticallyImplyLeading: false,
          toolbarOpacity: 0.8,
          actions: [
            DefaultTextStyle(
              style: GoogleFonts.raleway(fontSize: 14),
              child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Center(
                      child: Text(
                    'Deleted',
                    style: TextStyle(fontSize: 16),
                  ))),
            )
          ],
        ),
        body: GetX<CartController>(
          builder: (contrller) {
            if (contrller != null) {
              return contrller.showLoading.value
                  ? Center(child: Loading())
                  : SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: GetX<CartController>(
                                builder: (controller) {
                                  if (controller != null &&
                                      controller.cartprods != null)
                                    return ListView.builder(
                                        itemBuilder: (context, index) {
                                          return cartItems(
                                              controller.cartprods[index],
                                              controller);
                                        },
                                        itemCount:
                                            controller.cartprods.length ?? 0);
                                  else
                                    return Offstage();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
            } else
              return Offstage();
          },
        ),
      ),
    );
  }
}

Widget cartItems(CartModel cartModel, CartController cartController) {
  ProductModel productModel;
  final faker = Faker();
  cartController.proucts.forEach((element) {
    if (element.prodId == cartModel.prodId) {
      productModel = element;
    }
  });
  return Card(
    shadowColor: Colors.blueGrey.shade600,
    margin: EdgeInsets.all(8.8),
    clipBehavior: Clip.antiAlias,
    // shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.all(Radius.circular(10))),
    borderOnForeground: true,
    elevation: 4.0,
    child: Container(
      padding: EdgeInsets.all(7.5),
      child: Row(
        children: [
          SizedBox(
              width: 35,
              child: IconButton(
                icon: GetX<CartController>(
                  builder: (controller) {
                    if (controller != null)
                      return cartModel.selectedItem.value
                          ? Icon(
                              OMIcons.checkCircleOutline,
                              color: Colors.orange,
                            )
                          : Icon(OMIcons.radioButtonUnchecked);
                    else
                      return Offstage(
                        offstage: true,
                      );
                  },
                ),
                onPressed: () async {
                  Logger()..i('Clickd Radio');
                  if (cartModel.selectedItem.value) {
                    cartModel.selectedItem.toggle();
                    await cartController.removeThisitem(productModel);
                  } else {
                    cartModel.selectedItem.toggle();
                    await cartController.selectThisItem(productModel);
                  }
                },
              )),
          SizedBox(
            width: 5,
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: CachedNetworkImage(
              imageUrl: productModel.imageLink,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${faker.lorem.sentence()}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                          text: 'Rs. ${productModel.prodPrice}',
                          style: TextStyle(
                              color: Colors.orange[900], fontSize: 15),
                          children: [
                            TextSpan(
                                text: '\nRs. 2000',
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                    fontSize: 12))
                          ]),
                    ),
                    quantity(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget quantity() {
  return Container(
    child: Row(
      children: [
        IconButton(
            icon: Icon(
              OMIcons.remove,
              size: 19,
            ),
            onPressed: () {}),
        Container(
          padding: EdgeInsets.all(3.0),
          decoration: BoxDecoration(
              color: Colors.grey[700].withOpacity(.9),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: SizedBox(
            width: 25,
            height: 15,
            child: Center(
              child: Text(
                '1',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        IconButton(
            icon: Icon(
              OMIcons.add,
              size: 19,
            ),
            onPressed: () {}),
      ],
    ),
  );
}

//!BOttom app Bar
Widget bottomAppbar(CartController cartController) {
  return BottomAppBar(
    elevation: 0.0,
    clipBehavior: Clip.antiAlias,
    child: Container(
      padding: EdgeInsets.all(7.4),
      child: Container(
        margin: EdgeInsets.only(left: 8, right: 8),
        child: Row(
          children: [
            Expanded(
                child: Row(
              children: [
                GestureDetector(onTap: () {
                  Logger().i('tapped');
                  if (cartController.allSelected.value == true) {
                    cartController.removeAllItems();
                    cartController.allSelected.toggle();
                    Logger().i(cartController.allSelected.value);
                  } else {
                    cartController.allSelected.toggle();
                    Logger().i(cartController.allSelected.value);
                    cartController.selcctAllitems();
                  }
                }, child: GetX<CartController>(
                  builder: (controller) {
                    if (controller != null) {
                      return controller.allSelected.value &&
                              controller.productsAddedInCart.length ==
                                  controller.cartprods.length
                          ? Icon(
                              OMIcons.checkCircleOutline,
                              color: Colors.orange,
                            )
                          : Icon(OMIcons.radioButtonUnchecked);
                    } else
                      return Icon(OMIcons.radioButtonUnchecked);
                  },
                )),
                SizedBox(
                  width: 10,
                ),
                Text('All'),
              ],
            )),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: rasiedButton('Buy Now', null, () {
              // cartController.showLoading.toggle();

              Get.dialog(
                Loading(),
                useSafeArea: false,
                barrierDismissible: false,
                name: 'Omg',
                
              );
              Future.delayed(Duration(seconds: 5), () {
                Get.back(canPop: true);
              });

              // });
            })),
          ],
        ),
      ),
    ),
  );
}
