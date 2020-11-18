import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groceryuser/Controller/cart_controller.dart';
import 'package:groceryuser/Models/productmodel.dart';
import 'package:groceryuser/Screens/buynoowpage/components/checkoutcard.dart';

class Body extends StatelessWidget {
  final cont = Get.find<CartController>();
  final int pageno;
  final ProductModel productModel;

  Body({Key key, @required this.pageno, this.productModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        // margin: EdgeInsets.only(left: 10, top: 10),
        padding: EdgeInsets.all(17),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Checkout',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 25),
                  ),
                  // SizedBox(
                  //   height: 5.5,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      pageno == 1
                          ? Obx(
                              () => Text(
                                '${cont.productsAddedInCart.length ?? 0} Items',
                                style: TextStyle(
                                    color: Colors.grey[900].withOpacity(0.8),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                            )
                          : Text('1 Item',
                              style: TextStyle(
                                  color: Colors.grey[900].withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16)),
                      Icon(
                        Icons.info,
                        color: Colors.grey[800],
                      )
                    ],
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.grey[900],
              indent: 10,
              endIndent: 10,
            ),
            pageno == 1
                ? SizedBox(
                    height: MediaQuery.of(context).size.height / 2 + 40,
                    child: GetX<CartController>(
                      initState: (_) {},
                      builder: (controller) {
                        if (controller != null) {
                          return controller.productsAddedInCart != null
                              ? ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount:
                                      controller.productsAddedInCart.length ??
                                          0,
                                  itemBuilder: (context, index) {
                                    return CheckOutitemsCard(
                                      productModel:
                                          controller.productsAddedInCart[index],
                                    );
                                  },
                                )
                              : Offstage();
                        }
                        return Offstage();
                      },
                    ),
                  )
                : CheckOutitemsCard(
                    page: 0,
                    productModel: productModel,
                  ),
          ],
        ),
      ),
    );
  }
}
