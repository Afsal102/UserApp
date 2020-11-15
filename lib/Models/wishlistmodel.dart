import 'dart:convert';

import 'package:flutter/material.dart';

class WishListModel {
  String wishId;
  String prodId;
  String addedTime;
  String userId;
  String addeddate;
  WishListModel({
    @required this.wishId,
    @required this.prodId,
    @required this.addedTime,
    @required this.addeddate,
    @required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'wishId': wishId,
      'prodId': prodId,
      'addedTime': addedTime,
      'addeddate': addeddate,
      'userId':userId,
    };
  }


}
