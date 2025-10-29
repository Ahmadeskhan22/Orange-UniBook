import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/Services/auth_service.dart';
import '/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  bool _isLoading = false;
  Locale? _appLocale;
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  Locale? get appLocale => _appLocale;
  AuthViewModel() {
    _loadInitialState();
    _authService.authStateChanges.listen((User? user) {
      if (user != null) {
        _currentUser = UserModel.fromFirebaseUser(user);
      } else {
        _currentUser = null;
      }
      notifyListeners();
    });
  }
  Future<void> _loadInitialState() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('languageCode');

    if (langCode != null) {
      _appLocale = Locale(langCode);
    } else {
      _appLocale = const Locale('en');
    }
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
    _appLocale = Locale(languageCode);
    notifyListeners();
  }

  Future<String?> login(String emailOrPhone, String password) async {
    _isLoading = true;
    notifyListeners();
    String? errorMessage;
    try {
      final user = await _authService.signIn(
        emailOrPhone: emailOrPhone,
        password: password,
      );
      if (user != null) {
        _currentUser = UserModel.fromFirebaseUser(user);
      }
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    }
    _isLoading = false;
    notifyListeners();
    return errorMessage;
  }

  Future<String?> signUp({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) async {
    _isLoading = true;
    notifyListeners();
    String? errorMessage;
    try {
      final user = await _authService.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      if (user != null) {
        _currentUser = UserModel.fromFirebaseUser(user);
      }
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    }
    _isLoading = false;
    notifyListeners();
    return errorMessage;
  }

  Future<String?> sendPasswordReset(String email) async {
    _isLoading = true;
    notifyListeners();
    String? errorMessage;
    try {
      await _authService.sendPasswordResetEmail(email: email);
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    }
    _isLoading = false;
    notifyListeners();
    return errorMessage;
  }

  Future<void> logout() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
