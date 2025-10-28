import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeub/Carts/cart_controller.dart';
import 'Screens/products_screen(Home).dart';
import 'Screens/Cart_screen.dart';
import 'Screens/Checkout_screen.dart';
import 'Screens/Done_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartController()),
      ],
      child: MaterialApp(
        title: 'UniBook Store',
        debugShowCheckedModeBanner: false, // DEBUG
        home: ProductsScreen(),
      ),
    );
  }
}
