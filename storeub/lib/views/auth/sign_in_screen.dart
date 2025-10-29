import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/auth_view_model.dart';
import '../../core/constants.dart';
import 'sign_up_screen.dart';
import '../password_recovery/forgot_password_screen.dart';
import '../password_recovery/home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  String _emailOrPhone = '';
  String _password = '';

  bool _isPasswordVisible = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final viewModel = Provider.of<AuthViewModel>(context, listen: false);
      final error = await viewModel.login(_emailOrPhone, _password);

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // asset
              Image.asset(AppAssets.signIn.logoPath, height: 80),
              const Text(
                'Sign In',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 40),

              // Email field
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _emailOrPhone = value!.trim(),
                validator: (value) => value!.isEmpty ? 'email required!' : null,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
              const SizedBox(height: 15),

              // Password field
              TextFormField(
                obscureText: !_isPasswordVisible,
                onSaved: (value) => _password = value!,
                validator:
                    (value) =>
                        (value!.length < 8) ? 'At least 8 characters!' : null,
                decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.primaryBlack,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Forget Password ?',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              _buildSignInButton(viewModel),

              const SizedBox(height: 30),
              _buildSocialSeparator(),

              const SizedBox(height: 15),
              _buildSocialIcons(),

              const SizedBox(height: 40),
              _buildSignUpLink(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton(AuthViewModel viewModel) {
    if (viewModel.isLoading) {
      return const CircularProgressIndicator(color: AppColors.primaryOrange);
    } else {
      return ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Sign In',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      );
    }
  }

  Widget _buildSocialSeparator() {
    return const Row(
      children: [
        Expanded(child: Divider(color: Colors.black38)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Or Continue With",
            style: TextStyle(color: Colors.black54),
          ),
        ),
        Expanded(child: Divider(color: Colors.black38)),
      ],
    );
  }

  Widget _buildSocialIcons() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.apple, size: 40, color: AppColors.primaryBlack), // Apple
        SizedBox(width: 20),
        Icon(Icons.g_mobiledata_rounded, size: 40, color: Colors.red), // Google
        SizedBox(width: 20),
        Icon(Icons.facebook, size: 40, color: Colors.blue), // Facebook
      ],
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const SignUpScreen()));
      },
      child: const Text.rich(
        TextSpan(
          text: "Don't have an account? ",
          style: TextStyle(color: Colors.black54),
          children: [
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: AppColors.primaryOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
