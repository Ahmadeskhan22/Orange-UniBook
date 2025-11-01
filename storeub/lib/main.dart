import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:storeub/view_models/auth_view_model.dart';
import 'package:storeub/views/auth/started_screen.dart';
import 'package:storeub/core/constants.dart';

import 'package:storeub/Carts/cart_controller.dart';
import 'package:storeub/Screens/products_screen(Home).dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => CartController()),
      ],
      child: MaterialApp(
        title: 'Uni Book Store',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          primaryColor: AppColors.primaryOrange,
          primarySwatch: Colors.deepOrange,
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: AppColors.lightBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide.none,
            ),
          ),
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              color: AppColors.primaryBlack,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        home: Consumer<AuthViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.currentUser != null) {
              return ProductsScreen();
            }

            return StartedScreen();
          },
        ),
      ),
    );
  }
}
