import 'package:get/get.dart';
import 'package:groceryuser/Controller/product_controller.dart';
import 'package:groceryuser/Models/cart_model.dart';
import 'package:groceryuser/Models/productmodel.dart';
import 'package:groceryuser/Services/database.dart';

class CartController extends GetxController {
  Rx<List<CartModel>> cartItems = Rx<List<CartModel>>();
  List<ProductModel> get proucts => Get.find<ProductController>().prods;
  List<CartModel> get cartprods => cartItems.value;
  List<ProductModel> productsAddedInCart = List<ProductModel>().obs;
  var allSelected = false.obs;
  var showLoading = false.obs;

  double get totPrice => productsAddedInCart.fold(
      0, (sum, element) => sum + double.parse(element.prodPrice));

  Future selectThisItem(ProductModel productModel) async {
    productsAddedInCart.add(productModel);
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
      if (element.prodId == cartModel.prodId) productsAddedInCart.add(element);
    });

  }

  @override
  void onInit() {
    cartItems.bindStream(Database().cartstream);
    super.onInit();
  }
}
