import 'package:flutter/material.dart';
// ⚠️ ملاحظة: ستحتاج إلى ProductModel لتعريف البيانات الوهمية
// import '../Carts/CartItemModel.dart';

// تعريف نموذج وهمي (Mock) لاستخدامه في الواجهة فقط
class MockProductModel {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  MockProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });
}

class ProductsScreen extends StatelessWidget {
  ProductsScreen({Key? key}) : super(key: key);

  // =======================================================
  // 1. بيانات وهمية (Mock Data) لعرض التصميم
  // =======================================================
  final List<MockProductModel> dummyProducts = [
    MockProductModel(
      id: 'p1',
      title: 'Flutter University Textbook',
      price: 15.99,
      imageUrl:
          'https://via.placeholder.com/300x450.png/000000/FFFFFF?text=Book+Cover+1',
    ),
    MockProductModel(
      id: 'p2',
      title: 'Data Structures 101',
      price: 22.50,
      imageUrl:
          'https://via.placeholder.com/300x450.png/000000/FFFFFF?text=Book+Cover+2',
    ),
    MockProductModel(
      id: 'p3',
      title: 'Cyber Security Principles',
      price: 19.99,
      imageUrl:
          'https://via.placeholder.com/300x450.png/000000/FFFFFF?text=Book+Cover+3',
    ),
    MockProductModel(
      id: 'p4',
      title: 'Intro to AI & ML',
      price: 25.00,
      imageUrl:
          'https://via.placeholder.com/300x450.png/000000/FFFFFF?text=Book+Cover+4',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UniBook Store'),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  print('Cart icon pressed');
                },
              ),
              // Positioned( ... )
            ],
          ),
        ],
      ),
      // fake data
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: dummyProducts.length, //fake data
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, i) {
          final product = dummyProducts[i]; //  fake product

          return Card(
            elevation: 4,
            clipBehavior: Clip.antiAlias, //
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //  image for book
                Expanded(
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Image.asset(
                          'UX/mdi-light_image insidecart.png',
                          fit: BoxFit.cover,
                        ),
                  ),
                ),
                //  more info about book
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '\$${product.price.toStringAsFixed(2)} JD',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // add cart buttom
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: ربط بـ CartController
                          print('Added ${product.title} to cart');
                        },
                        icon: const Icon(Icons.add_shopping_cart, size: 18),
                        label: const Text('Add to Cart'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white, //
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
