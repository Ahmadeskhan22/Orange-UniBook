import 'package:flutter/material.dart';
import 'package:storeub/Carts/cart_controller.dart';
import 'package:storeub/Screens/Cart_screen.dart';
import 'package:storeub/Carts/CartItemModel.dart';
import 'package:provider/provider.dart';
import 'package:storeub/Services/product_service.dart';

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
  final ProductService productService = ProductService();
  String? selectedUniversity;
  ProductsScreen({Key? key}) : super(key: key);
  final List<String> universities = [
    // --- Public Universities ---
    'AABU',
    'UJ',
    'MU',
    'JUST',
    'HU',
    'BAU',
    'AHU',
    'TTU',
    'GJU',
    'AAU',
    'IU',
    'MEU',
    'ZU',
    'IAU',
    'JU',
    'Other',
  ];
  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: selectedUniversity,
              hint: Text(
                'Select University',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
              style: TextStyle(color: Colors.black, fontSize: 16),
              dropdownColor: Colors.orange[50],
              underline: Container(), //
              onChanged: (String? newValue) {
                //u should update class ProductModel --- add  a onChange

                selectedUniversity = newValue!;
              },
              items:
                  universities.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
            ),
          ],
        ),

        actions: [
          Consumer<CartController>(
            builder: (context, cart, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                    ),
                    tooltip: 'Open Cart',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                  ),
                  if (cart.cartItems.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        //counter++
                      ), //
                    ),
                ],
              );
            },
          ),
        ],

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, //
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                ),
                // TODO: إضافة Controller ومنطق البحث هنا
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: productService.fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }
          if (snapshot.hasError) {
            print("Error loading products${snapshot.error}");
            return const Center(
              child: Text(
                'An error occurred while loading books. Try again later.',
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text(' not found a book'));
          }

          final products = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (ctx, i) {
              final product = products[i];

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,

                        errorBuilder: (context, error, stackTrace) {
                          print(
                            "Wrong on loading image${product.imageUrl} - $error",
                          ); //
                          return Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: Image.asset(
                                'assets/images/mdi-light_image insidecart.png', //Default image
                                fit: BoxFit.contain,
                                width: 60,
                                height: 60,
                                errorBuilder:
                                    (__, ___, ____) => const Icon(
                                      Icons.menu_book,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '\$${product.price.toStringAsFixed(2)} JD',
                              style: const TextStyle(
                                color: Colors.deepOrange, //
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              width: double.infinity, //
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  cartController.addToCart(product);
                                  ScaffoldMessenger.of(
                                    context,
                                  ).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${product.title} Added to cart!',
                                      ),
                                      duration: Duration(seconds: 1),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.add_shopping_cart, size: 25),
                                label: Text(
                                  'Added to cart!',
                                  style: TextStyle(fontSize: 12),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }, //  itemBuilder
          );
        }, //  builder
      ), //  FutureBuilder
    ); //  Scaffold
  }
}
