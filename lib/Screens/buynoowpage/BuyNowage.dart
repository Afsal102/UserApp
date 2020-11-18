import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groceryuser/Controller/cart_controller.dart';
import 'package:groceryuser/Models/productmodel.dart';
import 'package:groceryuser/Screens/buynoowpage/components/body.dart';
import 'package:logger/logger.dart';

class BuyNow extends StatelessWidget {
  final List<ProductModel> porductstoBuy;
  final ccartController = Get.find<CartController>();
  final ProductModel productModel;
  final int page;

  BuyNow({Key key, this.porductstoBuy, @required this.page, this.productModel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomAppbar(),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              Icons.chevron_left,
              color: Colors.black,
              size: 35,
            ),
          ),
          onPressed: () {
            Get.back(canPop: true);
          },
        ),
        toolbarHeight: kToolbarHeight,
        elevation: 0.0,
        brightness: Brightness.dark,
      ),
      body: Body(
        pageno: page,
        productModel: productModel,
      ),
    );
  }

  //!BOttom app Bar
  Widget bottomAppbar() {
    return BottomAppBar(
      color: Colors.transparent.withOpacity(0.1),
      elevation: 0.0,
      notchMargin: 20,
      shape: AutomaticNotchedShape(RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35), topRight: Radius.circular(35)))),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 200,
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textInterface('Subtotal', null),
                textInterface(
                    'Rs. ${page == 1 ? ccartController.totPrice : productModel.singlePageQuantity * double.parse(productModel.prodPrice)}',
                    null),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textInterface('Tax', null),
                textInterface('Rs. 0.0', null),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textInterface('Total', FontWeight.w800),
                textInterface(
                    'Rs. ${page == 1 ? ccartController.totPrice : productModel.singlePageQuantity * double.parse(productModel.prodPrice)}',
                    FontWeight.w800),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: RaisedButton(
                    padding: EdgeInsets.all(15),
                    color: Colors.blueGrey[900],
                    onPressed: () {
                      ccartController.productsAddedInCart.forEach((element) {
                        Logger().i(element.quantityperProduct);
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19)),
                    child: Text(
                      'Check Out',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget textInterface(String title, FontWeight fontWeight) {
    return Text(
      title,
      style: TextStyle(fontWeight: fontWeight ?? null, fontSize: 15),
    );
  }
}
