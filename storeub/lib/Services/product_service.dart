import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:storeub/Carts/CartItemModel.dart';
import 'package:storeub/Carts/cart_controller.dart';

class ProductService {
  final String _apiUrl =
      'https://www.googleapis.com/books/v1/volumes?q=programming+flutter+university&maxResults=20'; // for twenty books

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List? items = data['items'] as List?;

        if (items == null) {
          if (kDebugMode) print('API not found a  book ');
          return []; //
        }

        return items.map((item) {
          final volumeInfo = item['volumeInfo'] as Map<String, dynamic>? ?? {};
          final imageLinks = volumeInfo['imageLinks'] as Map<String, dynamic>?;
          final saleInfo = item['saleInfo'] as Map<String, dynamic>?;
          final listPrice = saleInfo?['listPrice'] as Map<String, dynamic>?;

          return ProductModel(
            id:
                item['id'] ??
                'unknown_id_${DateTime.now().millisecondsSinceEpoch}',
            title: volumeInfo['title'] ?? 'null title  ',
            price: (listPrice?['amount'] as num?)?.toDouble() ?? 19.99,
            imageUrl:
                imageLinks?['thumbnail'] ??
                'https://via.placeholder.com/300x450.png/CCCCCC/FFFFFF?text=No+Image',
          );
        }).toList();
      } else {
        if (kDebugMode) print(' API: Status Code Wrong ${response.statusCode}');
        return []; //
      }
    } catch (e) {
      if (kDebugMode) print('Wrong to fetch a book $e');
      return []; //
    }
  }
}
