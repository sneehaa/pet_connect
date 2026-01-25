import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';

class UserPetDetailLoading extends StatefulWidget {
  const UserPetDetailLoading({super.key});

  @override
  State<UserPetDetailLoading> createState() => _UserPetDetailLoadingState();
}

class _UserPetDetailLoadingState extends State<UserPetDetailLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _fadeAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.background,
            AppColors.primaryOrange.withOpacity(0.05),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated paw prints floating around
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow circle
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.primaryOrange.withOpacity(0.1),
                              AppColors.primaryOrange.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Main loading container
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryOrange,
                        AppColors.primaryOrange.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryOrange.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Paw icon
                      AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value,
                            child: const Icon(
                              Icons.pets,
                              color: Colors.white,
                              size: 45,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Circular progress indicator
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    color: AppColors.primaryOrange,
                    strokeWidth: 3,
                    backgroundColor: AppColors.primaryOrange.withOpacity(0.1),
                  ),
                ),

                // Floating paw prints
                ...List.generate(3, (index) {
                  final angle = (index * 120) * 3.14159 / 180;
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final offset = 60 + (10 * _scaleAnimation.value);
                      return Transform.translate(
                        offset: Offset(
                          offset *
                              (index == 0 ? 1 : (index == 1 ? -0.5 : -0.5)),
                          offset *
                              (index == 0 ? 0 : (index == 1 ? 0.866 : -0.866)),
                        ),
                        child: Opacity(
                          opacity: 0.3 + (0.3 * _fadeAnimation.value),
                          child: Icon(
                            Icons.pets,
                            color: AppColors.primaryOrange,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),

            const SizedBox(height: 40),

            // Loading text with animation
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Column(
                    children: [
                      Text(
                        'Loading Pet Details',
                        style: AppStyles.headline3.copyWith(
                          color: AppColors.textBlack,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Finding the perfect furry friend...',
                        style: AppStyles.body.copyWith(
                          color: AppColors.textLightGrey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // Animated dots
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    final delay = index * 0.2;
                    final animValue = (_controller.value + delay) % 1.0;
                    final opacity = animValue < 0.5
                        ? animValue * 2
                        : (1.0 - animValue) * 2;

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryOrange.withOpacity(opacity),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
