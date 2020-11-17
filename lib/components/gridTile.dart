import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groceryuser/Models/productmodel.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class GridCard extends StatelessWidget {
  final ProductModel productModel;

  GridCard({Key key, this.productModel}) : super(key: key);
  final faker = Faker();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.7),
      ),
      child: SizedBox(
        height: 350,
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
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
            Container(
              child: Column(
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
                  Row(
                    children: [
                      Text(
                        'Rs. ${productModel.prodPrice}',
                        style: fontInterface(
                          16,
                          Colors.orangeAccent[700],
                        ),
                        maxLines: 1,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        'Rs. 800 -76%',
                        style: GoogleFonts.robotoSlab(
                            fontSize: 13,
                            decoration: TextDecoration.lineThrough,
                            decorationThickness: 2,
                            decorationColor: Colors.orange.withOpacity(0.9),

                            color: Colors.grey[900].withOpacity(0.7)),
                      ),
                    ],
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
            ),
          ],
        ),
      ),
    );
  }

  TextStyle fontInterface(double fontSize, Color color) {
    return GoogleFonts.robotoSlab(
        fontSize: fontSize ?? 13, color: color ?? Colors.black);
  }
}
