import 'package:storeub/Carts/CartItemModel.dart';
import 'package:flutter/material.dart';

class CartItemModel {
  final String productId;
  final String title;
  final double price;
  int quantity;
  final String imageUrl;
  CartItemModel({
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
  double get subtotal => price * quantity;
  //for count a sum of amoent for this iteam
  // factory CartItemModel.fromMap(Map<String, dynamic> map) {

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }
}
