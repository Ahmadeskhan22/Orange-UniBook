import 'package:storeub/Carts/CartItemModel.dart';

class OrderModel {
  final int userID;
  final String orderID;
  final double totalAmount;
  final String deliveryDetails;
  final String contactNumber; // ⬅️ إضافة حقل رقم التواصل
  final List<CartItemModel> items;

  OrderModel({
    required this.userID,
    required this.totalAmount,
    required this.deliveryDetails,
    required this.contactNumber, // ⬅️ متطلب جديد
    required this.items,
    required this.orderID,
  });

  // -----------------------------------------------------------------
  // دالة التحويل (toMap) للـ API
  //function tomap --- API
  // -----------------------------------------------------------------
  Map<String, dynamic> toMap() {
    return {
      'order_id': orderID,
      'user_id': userID,
      'total_amount': totalAmount,
      'delivery_details': deliveryDetails,
      'contact_number': contactNumber,

      'items': items.map((item) => item.toMap()).toList(),

      'order_date': DateTime.now().toIso8601String(),
      'status': 'Pending',
    };
  }
}
