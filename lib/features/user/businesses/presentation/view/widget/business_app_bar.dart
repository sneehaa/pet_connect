import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';

class BusinessAppBar extends StatelessWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onInfoPressed; // New callback

  const BusinessAppBar({
    super.key,
    required this.onBackPressed,
    required this.onInfoPressed, // Pass this from the screen
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 160, // Slightly shorter since info is in dialog
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primaryOrange,
      leading: IconButton(
        icon: _buildCircleIcon(Icons.arrow_back),
        onPressed: onBackPressed,
      ),
      actions: [
        IconButton(
          icon: _buildCircleIcon(Icons.info_outline),
          onPressed: onInfoPressed,
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: const Text(
          "Available Pets",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryOrange,
                AppColors.primaryOrange.withOpacity(0.8),
              ],
            ),
          ),
          child: Icon(
            Icons.pets,
            size: 60,
            color: Colors.white.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.primaryOrange, size: 20),
    );
  }
}
