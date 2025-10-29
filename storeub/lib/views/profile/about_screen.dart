import 'package:flutter/material.dart';
import '../../core/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  final String appMessage =
      'The Uni Book Store application is a project dedicated to the easy buying and selling of university textbooks.\n\n'
      'While this current version is not the final product, it represents a new beginning for our team to develop our skills and work better together.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About',
          style: TextStyle(
            color: AppColors.primaryBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryWhite,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_outline,
                size: 100,
                color: AppColors.primaryOrange,
              ),
              const SizedBox(height: 200),
              Text(
                appMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryBlack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
