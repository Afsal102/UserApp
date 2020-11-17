import 'package:get/get.dart';
import 'package:groceryuser/Models/productmodel.dart';
import 'package:groceryuser/Models/wishlistmodel.dart';
import 'package:groceryuser/Services/database.dart';

class Favouritecontroller extends GetxController {
  Rx<List<ProductModel>> products = Rx<List<ProductModel>>();
  Rx<List<WishListModel>> wishProducts = Rx<List<WishListModel>>();

  List<ProductModel> get prods => products.value != null
      ? products.value.reversed.toList()
      : products.value;
  List<WishListModel> get wishItems => wishProducts.value;
  int get productLength => products.value.length;

  @override
  void onInit() {
    products.bindStream(Database().productsStream);
    wishProducts.bindStream(Database().favouritesStream);

    
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
