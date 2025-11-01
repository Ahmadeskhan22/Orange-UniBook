import 'package:flutter/material.dart';
import 'package:storeub/core/constants.dart';
import 'package:storeub/views/auth/sign_in_screen.dart';

class StartedScreen extends StatelessWidget {
  StartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.started.backgroundPath),
                fit: BoxFit.cover,
              ),
            ),
            child: const ColoredBox(color: Colors.black54),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Spacer(flex: 3),

                // UB Logo
                Image.asset(
                  AppAssets.started.logoPath,
                  height: 100,
                  width: 100,
                ),
                const Text(
                  'Uni Book',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: AppColors.primaryWhite,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 5),
                const Text(
                  'University Textbook Store',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: AppColors.primaryWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const Spacer(flex: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to SignInScreen (PushReplacement)
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const SignInScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        color: AppColors.primaryWhite,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
