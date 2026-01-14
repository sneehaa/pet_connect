import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';

class BusinessAppBar extends StatelessWidget {
  final VoidCallback onBackPressed;

  const BusinessAppBar({super.key, required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.primaryWhite,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
            ],
          ),
          child: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
        ),
        onPressed: onBackPressed,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryOrange,
                AppColors.primaryOrange.withOpacity(0.7),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.business,
              size: 80,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ),
      ),
    );
  }
}
