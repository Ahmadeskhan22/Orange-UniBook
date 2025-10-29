import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryOrange = Color(0xFFFF7A2E);
  static const Color primaryBlack = Color(0xFF1E1E1E);
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color primaryWhite = Colors.white;
}

class AppAssets {
  // Global Assets (Assumed paths, these must exist in assets/images/global/)
  static const String globalLogoPath = 'assets/images/global/ub_logo.png';
  static const String successCheckPath = 'assets/images/global/fr.png';

  static const _Started started = _Started();
  static const _SignIn signIn = _SignIn();
  static const _SignUp signUp = _SignUp();
}

class _Started {
  const _Started();
  final String logoPath = 'assets/images/started/ub white.png';
  final String backgroundPath = 'assets/images/global/book.jpg';
}

class _SignIn {
  const _SignIn();
  final String logoPath = 'assets/images/sign_in/ub_logo.png';
}

class _SignUp {
  const _SignUp();
  final String logoPath = 'assets/images/sign_up/ub_logo.png';
}

class AppUtils {
  static bool isValidEmail(String email) {
    //check email
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  //length pass
  static bool isStrongPassword(String password) {
    return password.length >= 8;
  }
}
