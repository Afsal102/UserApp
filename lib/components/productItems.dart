import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groceryuser/Controller/loginController.dart';
import 'package:groceryuser/Controller/product_controller.dart';
import 'package:groceryuser/Models/productmodel.dart';
import 'package:groceryuser/Services/database.dart';
import 'package:groceryuser/components/textviews.dart';
import 'package:logger/logger.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class ProductItems extends StatelessWidget {
  final ProductModel productModel;

  ProductItems({Key key, @required this.productModel}) : super(key: key);
  final logger = Logger();
  final prodcontroller = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Container(
        margin: EdgeInsets.only(right: 5),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.all(3),
                        child: Text(
                          '1${productModel.weight.toUpperCase()}',
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      //!Icon on the row
                      Container(
                        child: GestureDetector(
                            onTap: () async {
                              logger.i('Tapped');
                              try {
                                if (productModel.isFavourite.value == true) {
                                  await Database()
                                      .deleteFromWishList(
                                          productModel.wishId.value)
                                      .then((value) {
                                    productModel.isFavourite.toggle();
                                  });
                                } else {
                                  productModel.isFavourite.toggle();
                                  if (await Database().addFavourites(
                                      productModel,
                                      Get.find<LoginConroller>()
                                          .user
                                          .uid
                                          .toString())) {
                                    Get.snackbar('Favourite List',
                                        'New product Added to wish List');
                                  }
                                }
                              } on FirebaseException catch (e) {
                                logger.e(e.message.toUpperCase());
                              } catch (e) {
                                logger.e(e.toString().toUpperCase());
                              }
                            },
                            child: GetX<ProductController>(
                              initState: (state) async {
                                QuerySnapshot snapshot = await Database()
                                    .getWishList(productModel.prodId,
                                        Get.find<LoginConroller>().user.uid);

                                if (snapshot.docs.isNotEmpty) {
                                  productModel.isFavourite.value = true;
                                  productModel.wishId.value =
                                      snapshot.docs[0].id;
                                }
                              },
                              builder: (controller) {
                                if (controller != null) {
                                  if (controller.isAddToFavourite.value ==
                                      false) {
                                    return productModel.isFavourite.value ==
                                            true
                                        ? Icon(
                                            OMIcons.favorite,
                                            color: Colors.red,
                                          )
                                        : Icon(
                                            OMIcons.favoriteBorder,
                                            color: Colors.red,
                                          );
                                  } else
                                    return Icon(
                                      OMIcons.favorite,
                                      color: Colors.red,
                                    );
                                }
                                return Offstage(
                                  offstage: true,
                                );
                              },
                            )),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Center(
                    child: ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl: productModel.imageLink,
                        height: 80,
                        width: 100,
                        fit: BoxFit.cover,
                        // placeholder: (context, url) {
                        //   return SizedBox(
                        //       height: 50,
                        //       width: 50,
                        //       child: Center(
                        //           child: CircularProgressIndicator(
                        //         strokeWidth: 4.0,
                        //       )));
                        // },
                        filterQuality: FilterQuality.low,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextView(
                        text: '${productModel.prodName}',
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextView(
                        text: 'RS ${productModel.prodPrice}.00',
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
