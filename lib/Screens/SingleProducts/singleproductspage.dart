import 'package:auto_size_text/auto_size_text.dart';
import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groceryuser/Controller/loginController.dart';
import 'package:groceryuser/Controller/product_controller.dart';
import 'package:groceryuser/Models/productmodel.dart';
import 'package:groceryuser/Screens/buynoowpage/BuyNowage.dart';
import 'package:groceryuser/Screens/buynoowpage/components/checkoutcard.dart';
import 'package:groceryuser/Services/database.dart';
import 'package:groceryuser/components/gridTile.dart';
import 'package:logger/logger.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class SingleProductPage extends StatelessWidget {
  final productController = Get.find<ProductController>();
  final ProductModel productModel;

  SingleProductPage({Key key, this.productModel}) : super(key: key);
  final logger = Logger();
  final faker = Faker();
  static const double _appBarBottomBtnPosition =
      24.0; //change this value to position your button vertically

  @override
  Widget build(BuildContext context) {
    final double itemWidth = MediaQuery.of(context).size.width / 2;
    return Scaffold(
        bottomNavigationBar: bottomAppbar(productModel),
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: CustomScrollView(
            cacheExtent: itemWidth*900,
            clipBehavior: Clip.antiAlias,
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                title: Text(
                  'Hello',
                  style: TextStyle(color: Colors.black),
                ),
                expandedHeight: 250,
                backgroundColor: Colors.green,
                leading: IconButton(
                  onPressed: () {
                    Get.back(canPop: true, closeOverlays: true);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                    background: CachedNetworkImage(
                  imageUrl: productModel.imageLink,
                  fit: BoxFit.cover,
                )),
              ),
              //!All Contetns excluding list and gridview
              SliverToBoxAdapter(

                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Rs. ${productModel.prodPrice}',
                                  // style: TextStyle(
                                  //   color: Colors.orange.shade700,
                                  //   fontSize: 20,
                                  // ),
                                  style: GoogleFonts.robotoSlab(
                                      fontSize: 19, color: Colors.amber),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '800',
                                  style: GoogleFonts.robotoSlab(
                                      fontSize: 16,
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: GetX<ProductController>(
                                    builder: (controler) {
                                      if (controler != null) {
                                        return productModel.isFavourite.value
                                            ? Icon(
                                                Icons.favorite,
                                                size: 20,
                                                color: Colors.red,
                                              )
                                            : Icon(
                                                Icons.favorite_border,
                                                size: 20,
                                                color: Colors.grey,
                                              );
                                      }
                                      return Offstage(
                                        offstage: true,
                                      );
                                    },
                                  ),
                                  onPressed: () async {
                                    logger.i('Tapped');
                                    try {
                                      if (productModel.isFavourite.value ==
                                          true) {
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
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.share,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {},
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              faker.lorem.sentences(3).toString(),
                              style: fontInterface(14, Colors.black),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SmoothStarRating(
                                onRated: (rating) {
                                  logger.i(rating);
                                },
                                starCount: 6,
                                rating: 0,
                                allowHalfRating: true,
                                size: 20,
                                isReadOnly: false,
                                filledIconData: Icons.star,
                                halfFilledIconData: Icons.star_half,
                                defaultIconData: Icons.star_border,
                                color: Colors.yellow,
                                borderColor: Colors.orange.shade500,
                                spacing: 2.0)
                          ],
                        ),
                      ),
                      Divider(),
                      //!Review Section
                      Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Ratings & Reviews (108)',
                                  style: fontInterface(15, Colors.grey),
                                ),
                                Text(
                                  'View All',
                                  style: fontInterface(13, Colors.amber),
                                ),
                              ],
                            ),
                            Divider(),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: (3 * 240).toDouble(),
                              child: ListView.builder(
                                shrinkWrap: true,
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                  return reviewCard(productModel, context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        child: Center(
                            child: Text(
                          'People Who view this Item Also viewed',
                          style: GoogleFonts.robotoSlab(fontSize: 15),
                        )),
                      ),

                      Divider(
                        height: 5.0,
                      ),
                    ],
                  ),
                ),
              ),
              //!Grid View
              SliverPadding(
                sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return GetX<ProductController>(
                          builder: (controller) {
                            if (controller != null &&
                                controller.prods != null) {
                              // return gridItems(
                              //     controller.prods[index], context);
                              return GridCard(
                                productModel: controller.prods[index],
                              );
                            }
                            return Offstage(
                              offstage: true,
                            );
                          },
                        );
                      },
                      childCount: productController.prods.length ?? 0,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        childAspectRatio: (300 / itemWidth) / 2,
                        mainAxisSpacing: 5)),
                padding: EdgeInsets.all(15),
              )
            ],
          ),
        ));
  }
}

//!BOttom app Bar
Widget bottomAppbar(ProductModel productModel) {
  return BottomAppBar(
    elevation: 0.0,
    clipBehavior: Clip.antiAlias,
    child: Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
              child: rasiedButton(
            'Add To Cart',
            Colors.blueGrey,
            () async {
              Database().addtoCart(productModel);
            },
          )),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: rasiedButton('Buy Now', null, () {
            Logger().i(productModel.quantityperProduct);
            Get.to(
                BuyNow(
                  page: 0,
                  productModel: productModel,
                ),
                popGesture: true,
                curve: Curves.elasticInOut,
                preventDuplicates: true);
          })),
        ],
      ),
    ),
  );
}

//!Raised Button
Widget rasiedButton(
  String text,
  Color color,
  VoidCallback onPressed,
) {
  return RaisedButton(
    splashColor: Colors.blueGrey.shade100,
    padding: const EdgeInsets.all(15),
    elevation: 0.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    onPressed: onPressed,
    color: color ?? Colors.orange.shade500,
    child: Text(
      '$text',
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    ),
  );
}

TextStyle fontInterface(double fontSize, Color color) {
  return GoogleFonts.robotoSlab(
      fontSize: fontSize ?? 13, color: color ?? Colors.black);
}

//!Review Card
Widget reviewCard(ProductModel model, BuildContext context) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${faker.person.name().capitalizeFirst}, - ${faker.date.dateTime().day} ${faker.date.month()} ${faker.date.year(maxYear: 2021, minYear: 2000)}',
              style: fontInterface(11, Colors.grey),
            ),
            SmoothStarRating(
                onRated: (rating) {},
                starCount: 6,
                rating: 0,
                allowHalfRating: true,
                size: 15,
                isReadOnly: false,
                filledIconData: Icons.star,
                halfFilledIconData: Icons.star_half,
                defaultIconData: Icons.star_border,
                color: Colors.yellow,
                borderColor: Colors.orange.shade500,
                spacing: 2.0)
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text('${faker.lorem.sentences(2).toString()}', maxLines: 4),
        SizedBox(
          height: 10,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            width: 100,
            height: 100,
            filterQuality: FilterQuality.medium,
            imageUrl: model.imageLink,
            fit: BoxFit.cover,
          ),
        ),
        Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Bubble(
                stick: true,
                margin: BubbleEdges.only(top: 10, left: 25),
                nip: BubbleNip.leftTop,
                color: Colors.grey,
                child: Text('${faker.lorem.sentences(1)}',
                    style: fontInterface(14, Colors.white),
                    maxLines: 2,
                    textAlign: TextAlign.right),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
          ],
        ),
      ],
    ),
  );
}

//!grid view Items
Widget gridItems(ProductModel productModel, BuildContext context) {
  return SizedBox(
    height: 350,
    width: 300,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: CachedNetworkImage(
              imageUrl: productModel.imageLink,
              filterQuality: FilterQuality.medium,
              width: 300,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.ltr,
          children: [
            AutoSizeText(
              '${faker.lorem.sentence()}',
              maxLines: 2,
              maxFontSize: 12,
              minFontSize: 12,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Rs. ${productModel.prodPrice}',
              style: fontInterface(
                16,
                Colors.orangeAccent[700],
              ),
              maxLines: 1,
            ),
            Text(
              'Rs. 800 -76%',
              style: GoogleFonts.robotoSlab(
                  fontSize: 13,
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey),
            ),
            SmoothStarRating(
                onRated: (rating) {},
                starCount: 5,
                rating: 2,
                allowHalfRating: true,
                size: 15,
                isReadOnly: false,
                filledIconData: Icons.star,
                halfFilledIconData: Icons.star_half,
                defaultIconData: Icons.star_border,
                color: Colors.deepOrange,
                borderColor: Colors.orange.shade500,
                spacing: 2.0),
          ],
        ),
      ],
    ),
  );
}
