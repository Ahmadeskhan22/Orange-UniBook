import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../view_models/auth_view_model.dart';
import 'account_info_screen.dart';
import '../auth/started_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Setting',
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
      body: ListView(
        children: [
          _buildSettingItem(
            context,
            title: 'Account info',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AccountInfoScreen(),
                ),
              );
            },
            showArrow: true,
          ),

          _buildSettingItem(
            context,
            title: 'Log out',
            onTap: () async {
              await viewModel.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => StartedScreen()),
                (Route<dynamic> route) => false,
              );
            },
            showArrow: true,
            titleColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required String title,
    IconData? icon,
    required VoidCallback onTap,
    bool showArrow = true,
    Color titleColor = AppColors.primaryBlack,
  }) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: TextStyle(fontSize: 16, color: titleColor)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) Icon(icon, color: AppColors.primaryBlack),
              if (showArrow)
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black54,
                ),
            ],
          ),
          onTap: onTap,
        ),
        const Divider(height: 1, indent: 20, endIndent: 20),
      ],
    );
  }
}
