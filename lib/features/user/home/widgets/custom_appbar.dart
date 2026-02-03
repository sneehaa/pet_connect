import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';

class CustomAppBar extends StatelessWidget {
  final int selectedIndex;
  final String userName;
  final int unreadNotificationCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onLogoutTap;
  final VoidCallback? onWalletTap;

  const CustomAppBar({
    super.key,
    required this.selectedIndex,
    this.userName = 'Pet Lover',
    this.unreadNotificationCount = 0,
    this.onNotificationTap,
    this.onWalletTap,
    this.onLogoutTap,
  });

  static final List<Map<String, dynamic>> _screenData = [
    {
      'title': 'Home',
      'icon_asset': 'assets/icons/home.png',
      'subtitle': 'Find your perfect pet',
    },
    {
      'title': 'Favorites',
      'icon_asset': 'assets/icons/favorite.png',
      'subtitle': 'Your saved pets',
    },
    {
      'title': 'Compatibility',
      'icon_asset': 'assets/icons/compatibility.png',
      'subtitle': 'Find your match',
    },
    {
      'title': 'Profile',
      'icon_asset': 'assets/icons/user.png',
      'subtitle': 'Your account settings',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenData = _screenData[selectedIndex];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 25),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Text(
                    'Welcome back,',
                    style: AppStyles.small.copyWith(
                      color: AppColors.textLightGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userName,
                    style: AppStyles.headline3.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textBlack,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  IconButton(
                    onPressed: onWalletTap,
                    icon: Icon(
                      Icons.account_balance_wallet_outlined,
                      color: AppColors.textBlack,
                      size: 24,
                    ),
                    tooltip: 'Wallet',
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onNotificationTap,
                    child: _buildActionButton(
                      icon: Image.asset(
                        'assets/icons/bell.png',
                        height: 24,
                        color: AppColors.textBlack,
                      ),
                      badgeCount: unreadNotificationCount,
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: onLogoutTap,
                    child: _buildActionButton(
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: Colors.redAccent,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      AppColors.primaryOrange,
                      AppColors.primaryOrange.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryOrange.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    screenData['icon_asset'] as String,
                    color: AppColors.primaryWhite,
                    height: 28,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      screenData['title'],
                      style: AppStyles.headline3.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textBlack,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      screenData['subtitle'],
                      style: AppStyles.small.copyWith(
                        fontSize: 14,
                        color: AppColors.textLightGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required Widget icon, int badgeCount = 0}) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          icon,
          if (badgeCount > 0)
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.errorRed,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryWhite, width: 2),
                ),
                child: Center(
                  child: Text(
                    badgeCount > 9 ? '9+' : badgeCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
