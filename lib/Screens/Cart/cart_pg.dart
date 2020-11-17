import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groceryuser/Controller/cart_controller.dart';
import 'package:groceryuser/Controller/loginController.dart';
import 'package:groceryuser/Models/cart_model.dart';
import 'package:groceryuser/Models/productmodel.dart';
import 'package:groceryuser/Screens/Signup/components/or_divider.dart';
import 'package:groceryuser/Screens/SingleProducts/singleproductspage.dart';
import 'package:groceryuser/Services/database.dart';
import 'package:groceryuser/components/FocusedMenuWrapper.dart';
import 'package:groceryuser/components/gridTile.dart';
import 'package:groceryuser/components/loading.dart';
import 'package:logger/logger.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class CartPage extends StatelessWidget {
  final cartController = Get.find<CartController>();
  final scrollControllr = ScrollController();

  @override
  Widget build(BuildContext context) {
    final double itemWidth = MediaQuery.of(context).size.width / 2;

    return DefaultTextStyle(
      style: GoogleFonts.raleway(),
      child: Scaffold(
          bottomNavigationBar: bottomAppbar(cartController),
          backgroundColor: Colors.grey[400].withOpacity(.9),
          appBar: buildAppBar(),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                GetX<CartController>(
                  builder: (controller) {
                    if (controller != null) {
                      return controller.cartprods.isEmpty
                          ? Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.no_stroller,
                                    color: Colors.brown[900],
                                    size: 80,
                                  ),
                                  Text('Its Empty'),
                                ],
                              )),
                            )
                          : Carts();
                    }
                    return Offstage();
                  },
                ),
                OrDivider(
                  text: '!Just For You!',
                  color: Colors.orange,
                  textColor: Colors.indigo[900].withRed(10),
                  thickness: 2.9,
                  fontSize: 19,
                ),
                GridItemsForCart(itemWidth: itemWidth)
              ],
            ),
          )),
    );
  }

//!AppBar
  AppBar buildAppBar() {
    return AppBar(
      toolbarHeight: kToolbarHeight + 15,
      backgroundColor: Colors.blueGrey[900].withOpacity(0.8),
      title: Container(
          padding: EdgeInsets.all(10),
          child:
              Obx(() => Text('My Cart(${cartController.cartprods.length})'))),
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
        Container(
            margin: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await cartController.deleteFromCart();
              },
            )),
      ],
    );
  }
}

class GridItemsForCart extends StatelessWidget {
  const GridItemsForCart({
    Key key,
    @required this.itemWidth,
  }) : super(key: key);

  final double itemWidth;

  @override
  Widget build(BuildContext context) {
    return GetX<CartController>(
      builder: (controller) {
        if (controller != null) {
          return controller.proucts.isNotEmpty
              ? Container(
                  child: GridView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    cacheExtent: 1000,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: (300 / itemWidth) / 2,
                        mainAxisSpacing: 9,
                        crossAxisSpacing: 7),
                    // controller: scrollControllr,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(10),
                    itemCount: controller.proucts.length ?? 0,
                    itemBuilder: (context, index) {
                      return GetX<CartController>(
                        initState: (_) async {
                          //!Querying the favourites and checking if this id matches the id in favourites and the reutrn snapshot
                          QuerySnapshot snapshot = await Database().getWishList(
                              controller.proucts[index].prodId,
                              Get.find<LoginConroller>().user.uid);

                          if (snapshot.docs.isNotEmpty) {
                            controller.proucts[index].isFavourite.value = true;
                            controller.proucts[index].wishId.value =
                                snapshot.docs[0].id;
                          }
                        },
                        builder: (_) {
                          return FocusedMenuItemHolder(
                            onAddToCartPressed: ()async{
                              Logger().i('Add t ocart pressed');
                             await Database().addtoCart(controller.proucts[index]);
                            },
                            icon: controller.proucts[index].isFavourite.value
                                ? Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                : Icon(Icons.favorite_border),
                            onPressed: () async {
                              showDialog();

                              try {
                                if (controller
                                        .proucts[index].isFavourite.value ==
                                    true) {
                                  await Database()
                                      .deleteFromWishList(controller
                                          .proucts[index].wishId.value)
                                      .then((value) {
                                    controller.proucts[index].isFavourite
                                        .toggle();
                                        cloeDialog();
                                  });
                                } else {
                                  controller.proucts[index].isFavourite
                                      .toggle();
                                  if (await Database().addFavourites(
                                      controller.proucts[index],
                                      Get.find<LoginConroller>()
                                          .user
                                          .uid
                                          .toString())) {
                                    cloeDialog();
                                    Get.snackbar('Favourite List',
                                        'New product Added to wish List');
                                  }
                                }
                              } on FirebaseException catch (e) {
                                cloeDialog();
                                Logger().e(e.message.toUpperCase());
                              } catch (e) {
                                cloeDialog();
                                Logger().e(e.toString().toUpperCase());
                              }
                            },
                            child: GridCard(
                              productModel: controller.proucts[index],
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              : Offstage();
        }
        return Offstage();
      },
    );
  }
}

showDialog() {
  Get.dialog(
    Loading(),
    useSafeArea: false,
    barrierDismissible: false,
    name: 'Omg',
    transitionDuration: Duration(seconds: 1),
  );
}

cloeDialog() {
  if (Get.isDialogOpen) Get.back();
}

//!Cart Builder
class Carts extends StatelessWidget {
  Carts({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<CartController>(
      builder: (controller) {
        if (controller != null && controller.cartprods != null)
          return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return cartItems(controller.cartprods[index], controller);
              },
              itemCount: controller.cartprods.length ?? 0);
        else
          return Offstage();
      },
    );
  }
}

//!Cart Items ??
Widget cartItems(CartModel cartModel, CartController cartController) {
  ProductModel productModel;
  final faker = Faker();
  cartController.proucts.forEach((element) {
    if (element.prodId == cartModel.prodId) {
      productModel = element;
    }
  });
  cartController.productsAddedInCart.forEach((element) {
    if (element.prodId == cartModel.prodId) {
      cartModel.selectedItem.value = true;
      element.quantityperProduct.value = cartModel.prodQuantity;
    }
  });

  return Card(
    color: Colors.white.withOpacity(0.7),
    shadowColor: Colors.blueGrey.shade600.withOpacity(0.5),
    margin: EdgeInsets.all(10.0).copyWith(bottom: 0.0),
    clipBehavior: Clip.antiAlias,
    // shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.all(Radius.circular(10))),
    borderOnForeground: true,
    elevation: .0,
    child: Container(
      padding: EdgeInsets.all(7.5),
      child: Row(
        children: [
          SizedBox(
              width: 35,
              child: IconButton(
                icon: GetX<CartController>(
                  initState: (state) {},
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
                  if (cartModel.selectedItem.value) {
                    cartModel.selectedItem.toggle();
                    await cartController.removeThisitem(productModel);
                  } else {
                    cartModel.selectedItem.toggle();
                    await cartController.selectThisItem(
                        productModel, cartModel);
                  }
                },
              )),
          SizedBox(
            width: 5,
          ),
          //!Image
          SizedBox(
            width: 100,
            height: 100,
            child: Container(
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(begin: Alignment.bottomRight, colors: [
                Colors.black.withOpacity(.4),
                Colors.black.withOpacity(.2),
              ])),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(
                  imageUrl: productModel.imageLink,
                  fit: BoxFit.cover,
                ),
              ),
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
                    quantity(cartModel, cartController, productModel),
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

Widget quantity(CartModel cartModel, CartController conttroller,
    ProductModel productModel) {
  return Container(
    child: Row(
      children: [
        IconButton(
            icon: cartModel.prodQuantity > 1
                ? Icon(
                    OMIcons.remove,
                    size: 19,
                  )
                : Icon(
                    OMIcons.remove,
                    size: 19,
                    color: Colors.transparent,
                  ),
            onPressed: () async {
              await conttroller.reduceItem(cartModel);
            }),
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
                '${cartModel.prodQuantity}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        IconButton(
            icon: cartModel.prodQuantity < int.parse(productModel.availableQty)
                ? Icon(
                    OMIcons.add,
                    size: 19,
                  )
                : Icon(
                    OMIcons.add,
                    size: 19,
                    color: Colors.transparent,
                  ),
            onPressed: () async {
              await conttroller.increaseItem(cartModel);
            }),
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
                      return controller.productsAddedInCart.length ==
                                  controller.cartprods.length &&
                              controller.cartprods.length != 0
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
            Obx(() => RichText(
                    text: TextSpan(
                        text: 'Shipping:\t',
                        style: TextStyle(color: Colors.black, fontSize: 11),
                        children: [
                      TextSpan(
                          text: 'Rs 0.0',
                          style:
                              TextStyle(color: Colors.deepOrangeAccent[400])),
                      TextSpan(
                          text: '\nTotal:',
                          style: TextStyle(fontSize: 14),
                          children: [
                            TextSpan(
                                text: '\tRs. ${cartController.totPrice}',
                                style: TextStyle(
                                    color: Colors.deepOrange[900],
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))
                          ]),
                    ]))),
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
