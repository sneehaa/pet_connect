import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/pets/domain/entity/pet_entity.dart';

class UserPetImageCarousel extends StatefulWidget {
  final UserPetEntity pet;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  const UserPetImageCarousel({
    super.key,
    required this.pet,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  State<UserPetImageCarousel> createState() => _UserPetImageCarouselState();
}

class _UserPetImageCarouselState extends State<UserPetImageCarousel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(
      begin: 0.8,
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
    return Stack(
      fit: StackFit.expand,
      children: [
        // Main image carousel
        if (widget.pet.photos.isNotEmpty)
          PageView.builder(
            controller: widget.pageController,
            itemCount: widget.pet.photos.length,
            onPageChanged: widget.onPageChanged,
            itemBuilder: (context, index) {
              return Hero(
                tag: 'pet-image-${widget.pet.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image with parallax effect
                    Image.network(
                      widget.pet.photos[index],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.background,
                                AppColors.primaryOrange.withOpacity(0.1),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                        : null,
                                    color: AppColors.primaryOrange,
                                    strokeWidth: 3,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                AnimatedBuilder(
                                  animation: _fadeAnimation,
                                  builder: (context, child) {
                                    return Opacity(
                                      opacity: _fadeAnimation.value,
                                      child: Icon(
                                        Icons.pets,
                                        size: 40,
                                        color: AppColors.primaryOrange,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryOrange.withOpacity(0.15),
                                AppColors.background,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryOrange.withOpacity(
                                      0.1,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.pets,
                                    size: 60,
                                    color: AppColors.primaryOrange,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Image unavailable',
                                  style: AppStyles.body.copyWith(
                                    color: AppColors.textLightGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          )
        else
          // Placeholder when no images
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryOrange.withOpacity(0.15),
                  AppColors.background,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryOrange.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.pets,
                      size: 80,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No photos available',
                    style: AppStyles.body.copyWith(
                      color: AppColors.textLightGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.3),
                Colors.transparent,
              ],
              stops: const [0.0, 0.3, 0.6],
            ),
          ),
        ),

        // Page indicators - Modern style
        if (widget.pet.photos.length > 1)
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.pet.photos.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: widget.currentPage == index ? 32 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    gradient: widget.currentPage == index
                        ? LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.white.withOpacity(0.8),
                            ],
                          )
                        : null,
                    color: widget.currentPage == index
                        ? null
                        : Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: widget.currentPage == index
                        ? [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
            ),
          ),

        // Adopted badge - Enhanced
        if (!widget.pet.available)
          Positioned(
            top: 70,
            right: 20,
            child: Transform.rotate(
              angle: -0.1,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.errorRed,
                      AppColors.errorRed.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.errorRed.withOpacity(0.5),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Adopted',
                      style: AppStyles.small.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Photo count indicator
        if (widget.pet.photos.length > 1)
          Positioned(
            top: 70,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.photo_library,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${widget.currentPage + 1}/${widget.pet.photos.length}',
                    style: AppStyles.small.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
