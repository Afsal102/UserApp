import 'package:get/get.dart';

class ProductModel {
  String prodId,
      prodName,
      prodPrice,
      availableQty,
      weight,
      uploadDate,
      imageLink;

  ProductModel(
      {this.prodName,
      this.prodPrice,
      this.availableQty,
      this.weight,
      this.uploadDate,
      this.imageLink,
      this.prodId});

  Map<String, dynamic> toMap() {
    return {
      "prodName": this.prodName,
      "prodPrice": this.prodPrice,
      "availableQty": this.availableQty,
      "weight": this.weight,
      "uploadDate": this.uploadDate,
      "prodId": this.prodId,
      "imageLink": this.imageLink,
    };
  }

  final isFavourite = false.obs;
  final wishId = ''.obs;
  final quantityperProduct = 0.obs;


}
