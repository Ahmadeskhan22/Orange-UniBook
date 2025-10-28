import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeub/Carts/cart_controller.dart';
import 'package:storeub/Carts/CartItemModel.dart';
import 'Checkout_screen.dart';
import 'Done_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body:
          cartController.cartItems.isEmpty
              ////notes******** items using for class? cartmodelitem?
              ? Center(
                child: Text(
                  'Your cart is empty!',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(16.0),
                      itemCount:
                          cartController
                              .cartItems
                              .length, ////notes******** items using for class? cartmodelitem?
                      itemBuilder: (context, i) {
                        final item =
                            cartController
                                .cartItems[i]; ////notes******** items using for class? cartmodelitem?
                        return CartItemCard(item: item);
                      },
                    ),
                  ),
                  PaymentSummaryWidget(),
                  CartActionButtons(),
                  SizedBox(height: 16),
                ],
              ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  const CartItemCard({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context, listen: false);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Image.asset(
                        // API -----
                        'UX/mdi-light_image insidecart.png', //fake url for image---add it by  API
                        fit: BoxFit.cover,
                      ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  const Text(
                    'features', // API
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Price : \$${item.price.toStringAsFixed(2)} JD', // API
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    cartController.removeFromCart(item.productId);
                  },
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        cartController.updateQuantity(
                          //create function inside cartController
                          item.productId,
                          item.quantity - 1,
                        );
                      },
                    ),

                    Text(
                      '${item.quantity}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        cartController.updateQuantity(
                          ////create function inside cartController
                          item.productId,
                          item.quantity + 1,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentSummaryWidget extends StatelessWidget {
  const PaymentSummaryWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context);

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('subtotal', style: TextStyle(fontSize: 16)),
              Text(
                '\$${cartController.totalAmount.toStringAsFixed(2)} JD',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('Service fee', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 4),
                  Icon(Icons.info_outline, size: 16, color: Colors.grey),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.attach_money, size: 16, color: Colors.grey),
                  SizedBox(width: 2),

                  Text('0.00 JD', style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),

          const Divider(height: 25, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total amount',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${cartController.totalAmount.toStringAsFixed(2)} JD',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CartActionButtons extends StatelessWidget {
  const CartActionButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                //return to screen of books (prodcuts)
                Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                ); //  retrun to first screen
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: BorderSide(color: Colors.orange),
              ),
              child: Text(
                'Add items',
                style: TextStyle(fontSize: 16, color: Colors.orange),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutScreen(),
                  ), //create CheckoutScreen late
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              child: Text(
                'Checkout',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
