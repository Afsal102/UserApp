import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groceryuser/Controller/product_controller.dart';
import 'package:groceryuser/Models/productmodel.dart';
import 'package:groceryuser/Screens/SingleProducts/singleproductspage.dart';
import 'package:groceryuser/components/productItems.dart';

class Home extends StatelessWidget {
  final controller = Get.put(ProductController());
  final options = LiveOptions(
    // Start animation after (default zero)
    delay: Duration(milliseconds: 50),
    reAnimateOnVisibility: false,

    // Show each item through (default 250)
    showItemInterval: Duration(milliseconds: 50),

    // Animation duration (default 250)
    showItemDuration: Duration(milliseconds: 50),
    // Animations starts at 0.05 visible
    // item fraction in sight (default 0.025)
    // visibleFraction: 0.05,

    // Repeat the animation of the appearance
    // when scrolling in the opposite direction (default false)
    // To get the effect as in a showcase for ListView, set true
    // reAnimateOnVisibility: false,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 250,
              child: Carousel(
                boxFit: BoxFit.cover,
                images: [
                  CachedNetworkImage(
                    imageUrl:
                        'https://1.bp.blogspot.com/-HP-ZbI1Xfrk/WmNIIZB9wQI/AAAAAAAAAVs/dSvH03XYP_UF8aoftSUncsqUAXiKKXlbgCLcBGAs/s1600/download%2B%25281%2529.jpg',
                    filterQuality: FilterQuality.medium,
                    fit: BoxFit.cover,
                  ),
                  CachedNetworkImage(
                    imageUrl:
                        'https://1.bp.blogspot.com/-HP-ZbI1Xfrk/WmNIIZB9wQI/AAAAAAAAAVs/dSvH03XYP_UF8aoftSUncsqUAXiKKXlbgCLcBGAs/s1600/download%2B%25281%2529.jpg',
                    filterQuality: FilterQuality.medium,
                    fit: BoxFit.cover,
                  ),
                  CachedNetworkImage(
                    imageUrl:
                        'https://1.bp.blogspot.com/-HP-ZbI1Xfrk/WmNIIZB9wQI/AAAAAAAAAVs/dSvH03XYP_UF8aoftSUncsqUAXiKKXlbgCLcBGAs/s1600/download%2B%25281%2529.jpg',
                    filterQuality: FilterQuality.medium,
                    fit: BoxFit.cover,
                  ),
                ],
                animationCurve: Curves.fastOutSlowIn,
                animationDuration: Duration(milliseconds: 1000),
                dotSize: 4.0,
                dotSpacing: 15.0,
                dotColor: Colors.lightGreenAccent,
                indicatorBgPadding: 5.0,
                borderRadius: false,
                autoplay: true,
                autoplayDuration: Duration(seconds: 5),
                // moveIndicatorFromBottom: 180,
                noRadiusForIndicator: true,
                dotHorizontalPadding: 20.0,
                overlayShadow: true,
                overlayShadowColors: Colors.blueGrey.withOpacity(0.5),
                dotBgColor: Colors.blueGrey.withOpacity(0.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Popular Products',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            //!horizontal products

            SizedBox(
              height: 220,
              child: GetX<ProductController>(
                builder: (controller) {
                  if (controller != null && controller.prods != null) {
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      cacheExtent: (150 * controller.prods.length).toDouble(),
                      padding: EdgeInsets.all(10),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(
                                SingleProductPage(
                                  productModel: controller.prods[index],
                                ),
                                transition: Transition.noTransition,
                                curve: Curves.elasticInOut,
                                opaque: false,
                                popGesture: true,
                                preventDuplicates: true,
                                duration: Duration.zero,
                                fullscreenDialog: true);
                          },
                          child: ProductItems(
                              productModel: controller.prods[index]),
                        );
                      },
                      itemCount: controller.prods.length,
                    );
                  }
                  return Offstage(
                    offstage: true,
                  );
                },
              ),
            )
          ],
        )),
      ),
    );
  }

  // Build animated item (helper for all examples)
  Widget buildAnimatedItem(
    BuildContext context,
    ProductModel productModel,
    Animation<double> animation,
  ) =>
      // For example wrap with fade transition
      FadeTransition(
        opacity: Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animation),
        // And slide transition
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, -0.1),
            end: Offset.zero,
          ).animate(animation),
          // Paste you Widget
          child: ProductItems(productModel: productModel),
        ),
      );
}
