import 'package:cached_network_image/cached_network_image.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:groceryuser/Models/productmodel.dart';

class CheckOutitemsCard extends StatelessWidget {
  final ProductModel productModel;
  final int page;
  CheckOutitemsCard({
    Key key,
    this.productModel,
    this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: CachedNetworkImage(
                imageUrl: productModel.imageLink,
                fit: BoxFit.cover,
                height: 150,
                width: 130,
              ),
            ),
          ),
          SizedBox(
            width: 8.5,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${faker.lorem.sentence()}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                          // text: 'Rs. ${productModel.prodPrice}',
                          text: 'Rs. ${double.parse(productModel.prodPrice)}',
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
                    // quantity(cartModel, cartController, productModel),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'x${page==0? productModel.singlePageQuantity:productModel.quantityperProduct}',
                      style: TextStyle(
                          color: Colors.orange.shade900,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     IconButton(
                    //       icon: productModel.quantityperProduct > 1
                    //           ? Icon(
                    //               Icons.remove,
                    //               size: 19,
                    //             )
                    //           : Icon(
                    //               Icons.remove,
                    //               color: Colors.transparent,
                    //             ),
                    //       onPressed: () {},
                    //     ),
                    //     SizedBox(
                    //       width: 5.5,
                    //     ),
                    //     IconButton(
                    //       icon: Icon(
                    //         Icons.add,
                    //         size: 19,
                    //       ),
                    //       onPressed: () {},
                    //     ),
                    //   ],
                    // ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
