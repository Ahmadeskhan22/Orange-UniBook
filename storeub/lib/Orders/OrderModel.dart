import 'package:storeub/Carts/CartItemModel.dart';

class OrderModel {
  final int userID;
  final String orderID;
  final double totalAmount;
  final String deliveryDetails;
  final List<CartItemModel> items;
  OrderModel({
    required this.userID,
    required this.totalAmount,
    required this.deliveryDetails,
    required this.items,
    required this.orderID,
  });
  Map<String, dynamic> toMap() {
    return {
      'orderID': orderID,
      'userID': userID,
      'totalAmount': totalAmount,
      'deliveryDetails': deliveryDetails,
      'items': items.map((items) => items.toMap()).toList(),
      'orderDate': DateTime.now().toIso8601String(),
      'status': 'Pending',
    };
  }
}
