import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';

class NoQuestionnairePage extends StatelessWidget {
  final VoidCallback onStartQuestionnaire;
  final VoidCallback onRetry;
  final bool isLoading;

  const NoQuestionnairePage({
    super.key,
    required this.onStartQuestionnaire,
    required this.onRetry,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Pet Compatibility', style: AppStyles.headline3),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: AppColors.textDarkGrey),
            onPressed: isLoading ? null : onRetry,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeroIllustration(),
              const SizedBox(height: 40),
              Text(
                'Find Your Perfect Match',
                style: AppStyles.headline2.copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Every pet has a personality. Complete our quick questionnaire to see which furry friend fits your lifestyle best!',
                style: AppStyles.body.copyWith(color: AppColors.textGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _buildStartButton(),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: CircularProgressIndicator(
                    color: AppColors.primaryOrange,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
        ),

        const Icon(
          Icons.favorite_rounded,
          size: 100,
          color: AppColors.primaryOrange,
        ),

        Positioned(
          top: 20,
          right: 20,
          child: Icon(
            Icons.pets,
            color: AppColors.primaryOrange.withOpacity(0.5),
            size: 30,
          ),
        ),
        Positioned(
          bottom: 20,
          left: 10,
          child: Icon(
            Icons.auto_awesome,
            color: AppColors.warningYellow,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: isLoading ? null : onStartQuestionnaire,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: AppColors.primaryOrange.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Begin Discovery', style: AppStyles.button),
            const SizedBox(width: 12),
            const Icon(Icons.arrow_forward_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}
