import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groceryuser/Controller/product_controller.dart';
import 'package:groceryuser/Models/cart_model.dart';
import 'package:groceryuser/Models/productmodel.dart';
import 'package:groceryuser/Screens/buynoowpage/BuyNowage.dart';
import 'package:groceryuser/Services/database.dart';
import 'package:groceryuser/components/loading.dart';
import 'package:logger/logger.dart';

class CartController extends GetxController {
  Rx<List<CartModel>> cartItems = Rx<List<CartModel>>();
  List<ProductModel> get proucts => Get.find<ProductController>().prods;
  List<CartModel> get cartprods => cartItems.value;
  //!when clicked the rado button
  List<ProductModel> productsAddedInCart = List<ProductModel>().obs;
  var allSelected = false.obs;
  var showLoading = false.obs;

  double get totPrice => productsAddedInCart.fold(
      0,
      (sum, element) =>
          sum +
          (double.parse(element.prodPrice) * element.quantityperProduct.value));

  Future selectThisItem(ProductModel productModel, CartModel cartModel) async {
    productsAddedInCart.add(productModel);
    productModel.quantityperProduct.value = cartModel.prodQuantity;
  }

  Future removeThisitem(ProductModel productModel) async {
    productsAddedInCart
        .removeWhere((element) => element.prodId == productModel.prodId);
  }

  Future selcctAllitems() async {
    productsAddedInCart.clear();
    cartprods.forEach((element) {
      element.selectedItem.value = true;
      _findItemAndAddToCheckedCart(element);
    });
  }

  Future removeAllItems() async {
    cartprods.forEach((element) {
      element.selectedItem.value = false;
    });
    productsAddedInCart.clear();
  }

  //!To add all items to cart by change the value of obseverable
  _findItemAndAddToCheckedCart(CartModel cartModel) {
    proucts.forEach((element) {
      if (element.prodId == cartModel.prodId) {
        productsAddedInCart.add(element);
        element.quantityperProduct.value = cartModel.prodQuantity;
      }
    });
  }

  //!reduce itemquantity
  Future reduceItem(CartModel cartModel) async {
    if (cartModel.prodQuantity > 1) {
      showdialog();
      await Database()
          .updatecart(cartModel.id, (cartModel.prodQuantity - 1.round()));
      closeDialog();
    }
  }

//!increse item quantity
  Future increaseItem(CartModel cartModel) async {
    showdialog();
    await Database()
        .updatecart(cartModel.id, (cartModel.prodQuantity + 1.round()));
    closeDialog();
    // if(cartModel.selectedItem.value)cartModel.selectedItem.toggle();
    print(cartModel.selectedItem.value);
  }

  @override
  void onInit() {
    cartItems.bindStream(Database().cartstream);
    super.onInit();
  }

  showdialog() {
    Get.dialog(
      Loading(),
      useSafeArea: false,
      barrierDismissible: false,
      name: 'Omg',
    );
  }

  closeDialog() {
    if (Get.isDialogOpen) Get.back();
  }

  //!delete from cart
  Future deleteFromCart() async {
    if (productsAddedInCart.isNotEmpty) {
      productsAddedInCart.forEach((element) async {
        await Database().deleteFromCart(element);
      });
      if (productsAddedInCart.isNotEmpty) {
        productsAddedInCart.clear();
        Get.snackbar('Deleted', 'Deleted item');
        allSelected.value = false;
      }
    } else {
      Get.snackbar('No Items', 'No items To delete From cart',
          backgroundColor: Colors.blueGrey);
    }
  }

//!Called when checkout is called ex : like for cart how many items areselected
  proceedToCheckOut() {
    if (productsAddedInCart.isEmpty) {
      Get.snackbar('Select A product TO Go To CheckOut', 'TO Go To CheckOut');
    } else {
      Get.to(
          BuyNow(
            page: 1,
            porductstoBuy: productsAddedInCart,
          ),
          popGesture: true);
    }
  }
}
