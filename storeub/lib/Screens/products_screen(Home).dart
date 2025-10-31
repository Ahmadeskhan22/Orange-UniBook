import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeub/Carts/cart_controller.dart';
import 'package:storeub/Carts/CartItemModel.dart';
import 'package:storeub/Services/product_service.dart';
import 'package:storeub/Screens/Cart_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ProductService productService = ProductService();

  String? _selectedUniversity;
  final TextEditingController _searchController = TextEditingController();

  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = true;
  late Future<List<ProductModel>> _productsFuture;

  final List<String> universities = const [
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
  void initState() {
    super.initState();
    _productsFuture = productService.fetchProducts();
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterProducts);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchAndSetProducts(List<ProductModel> products) async {
    _allProducts = products;
    _filteredProducts = _allProducts;
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredProducts =
          _allProducts.where((product) {
            final titleLower = product.title.toLowerCase();
            return titleLower.contains(query);
          }).toList();
    });
  }

  void _onUniversityChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedUniversity = newValue;
        print('University Selected: $_selectedUniversity');
        _filterProducts();
      });
    }
  }

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
              value: _selectedUniversity,
              hint: const Text(
                'Select University',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              style: const TextStyle(color: Colors.black, fontSize: 16),
              dropdownColor: Colors.orange[50],
              underline: Container(),
              onChanged: _onUniversityChanged,
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
                    icon: const Icon(
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
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cart.cartItems.length}', // ️
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 8.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: TextField(
                controller: _searchController, //
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search Books...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _productsFuture, //  Future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }

          if (snapshot.hasError) {
            print("Error loading products: ${snapshot.error}");
            return const Center(
              child: Text('An error occurred while loading books.'),
            );
          }

          if (snapshot.hasData && _allProducts.isEmpty) {
            _fetchAndSetProducts(snapshot.data!);
          }

          if (_filteredProducts.isEmpty && _searchController.text.isNotEmpty) {
            return Center(
              child: Text('No results found for "${_searchController.text}".'),
            );
          }
          if (_filteredProducts.isEmpty) {
            return const Center(child: Text('No books found.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: _filteredProducts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3.6, //
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (ctx, i) {
              final product = _filteredProducts[i];

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
                          );
                          return Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: Image.asset(
                                'assets/images/mdi-light_image insidecart.png',
                                fit: BoxFit.contain,
                                width: 60,
                                height: 60,
                                errorBuilder:
                                    (_, __, ___) => const Icon(
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              product.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '\$${product.price.toStringAsFixed(2)} JD',
                              style: const TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
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
                                      duration: const Duration(seconds: 1),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.add_shopping_cart,
                                  size: 16,
                                ),
                                label: const Text(
                                  'Add to cart!',
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
            },
          );
        },
      ),
    );
  }
}
