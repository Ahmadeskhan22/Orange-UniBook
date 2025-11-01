import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/auth_view_model.dart';
import '../../core/constants.dart';
import '../password_recovery/verification_success_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  // api pub
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _phoneNumber = '';
  String _password = '';

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final viewModel = Provider.of<AuthViewModel>(context, listen: false);

      final error = await viewModel.signUp(
        firstName: _firstName,
        lastName: _lastName,
        email: _email,
        password: _password,
        phoneNumber: _phoneNumber,
      );

      if (error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Registration error: $error')));
      } else if (viewModel.currentUser != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (context) => const VerificationSuccessScreen(
                  message:
                      'The account has been created successfully. Please check your email to activate the account.',
                ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ), //back b
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset('assets/images/sign_up/ub_logo(1).png', height: 80),
              const Text(
                'Sign Up',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),
              TextFormField(
                onSaved: (v) => _firstName = v!,
                decoration: const InputDecoration(hintText: 'First Name'),
              ),
              const SizedBox(height: 15),
              TextFormField(
                onSaved: (v) => _lastName = v!,
                decoration: const InputDecoration(hintText: 'Last Name'),
              ),
              const SizedBox(height: 15),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                onSaved: (v) => _email = v!,
                validator:
                    (v) =>
                        AppUtils.isValidEmail(v!)
                            ? null
                            : 'Invalid email address',
                decoration: const InputDecoration(hintText: 'Email'),
              ),
              const SizedBox(height: 15),
              TextFormField(
                onSaved: (v) => _phoneNumber = v!,
                validator: (v) => (v != null && v.isNotEmpty) ? null : null,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: 'Phone Number'),
              ),
              const SizedBox(height: 15),
              TextFormField(
                obscureText: true,
                onSaved: (v) => _password = v!,
                validator:
                    (v) =>
                        AppUtils.isStrongPassword(v!)
                            ? null
                            : 'At least 8 characters!',
                decoration: const InputDecoration(hintText: 'Password'),
              ),

              const SizedBox(height: 40),

              // Sign Up Button
              if (viewModel.isLoading)
                const CircularProgressIndicator(color: AppColors.primaryOrange)
              else
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
