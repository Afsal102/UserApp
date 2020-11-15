import 'dart:convert';

import 'package:groceryuser/Models/productmodel.dart';
import 'package:get/get.dart';

class CartModel {
  String id;
  String prodId;
  String userId;
  int prodQuantity;
  String date;
  String time;

  CartModel({
    this.id,
    this.prodId,
    this.userId,
    this.prodQuantity,
    this.date,
    this.time,
  });

  CartModel copyWith({
    String id,
    String prodId,
    String userId,
    int prodQuantity,
    String date,
    String time,
  }) {
    return CartModel(
      id: id ?? this.id,
      prodId: prodId ?? this.prodId,
      userId: userId ?? this.userId,
      prodQuantity: prodQuantity ?? this.prodQuantity,
      date: date ?? this.date,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'prodId': prodId,
      'userId': userId,
      'prodQuantity': prodQuantity,
      'date': date,
      'time': time,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CartModel(
      id: map['id'],
      prodId: map['prodId'],
      userId: map['userId'],
      prodQuantity: map['prodQuantity'],
      date: map['date'],
      time: map['time'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) =>
      CartModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CartModel(id: $id, prodId: $prodId, userId: $userId, prodQuantity: $prodQuantity, date: $date, time: $time)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CartModel &&
        o.id == id &&
        o.prodId == prodId &&
        o.userId == userId &&
        o.prodQuantity == prodQuantity &&
        o.date == date &&
        o.time == time;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        prodId.hashCode ^
        userId.hashCode ^
        prodQuantity.hashCode ^
        date.hashCode ^
        time.hashCode;
  }

  final productmodel = ProductModel().obs;
  final selectedItem = false.obs;
}
