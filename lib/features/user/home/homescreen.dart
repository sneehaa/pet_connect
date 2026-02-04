import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/notifications/presentation/view/user_notifications_screen.dart';
import 'package:pet_connect/features/notifications/presentation/viewmodel/notification_view_model.dart';
import 'package:pet_connect/features/user/auth/presentation/auth_viewmodel/auth_viewmodel.dart';
import 'package:pet_connect/features/user/businesses/presentation/view/business_detail_screen.dart';
import 'package:pet_connect/features/user/businesses/presentation/view/widget/business_card.dart';
import 'package:pet_connect/features/user/businesses/presentation/viewmodel/business_viewmodel.dart';
import 'package:pet_connect/features/user/home/widgets/custom_appbar.dart';
import 'package:pet_connect/features/user/payment/presentation/view/screens/wallet_screen.dart';
import 'package:pet_connect/features/user/profile/presentation/view/profile_screen.dart';
import 'package:pet_connect/features/user/profile/presentation/viewmodel/profile_viewmodel.dart';
import 'package:pet_connect/utils/login_choice.dart';
import 'package:pet_connect/widgets/custom_navbar.dart';

class Homescreen extends ConsumerStatefulWidget {
  const Homescreen({super.key});

  @override
  ConsumerState<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(businessViewModelProvider.notifier).getAllBusinesses();
      ref.read(notificationViewModelProvider.notifier).getUserNotifications();
    });
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Logout',
            style: AppStyles.headline3.copyWith(color: AppColors.textBlack),
          ),
          content: Text(
            'Are you sure you want to sign out of Pet Connect?',
            style: AppStyles.body.copyWith(color: AppColors.textGrey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppStyles.body.copyWith(color: AppColors.textLightGrey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                await ref.read(authViewModelProvider.notifier).logout();

                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginChoiceScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
              child: Text(
                'Logout',
                style: AppStyles.button.copyWith(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Consumer(
            builder: (context, ref, _) {
              final notificationState = ref.watch(
                notificationViewModelProvider,
              );
              final unreadCount = notificationState.unreadCount;

              final profileState = ref.watch(userProfileViewModelProvider);

              String userName = 'User';

              if (profileState.userProfile != null) {
                userName = profileState.userProfile!.username;
              }

              return CustomAppBar(
                selectedIndex: _selectedIndex,
                userName: userName,
                unreadNotificationCount: unreadCount,
                onNotificationTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserNotificationsScreen(),
                    ),
                  ).then((_) {
                    ref
                        .read(notificationViewModelProvider.notifier)
                        .getUserNotifications();
                  });
                },
                onWalletTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WalletScreen(),
                    ),
                  );
                },
                onLogoutTap: () => _showLogoutDialog(context, ref),
              );
            },
          ),
          Expanded(
            child: Container(
              color: AppColors.background,
              child: _getSelectedPage(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTabChanged: _onTabChanged,
      ),
    );
  }

  // ... rest of the code remains the same ...
  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildBusinessListPage();
      case 1:
        return _buildFavoritesPage();
      case 2:
        return _buildCompatibilityPage();
      case 3:
        return const ProfileScreen();
      default:
        return _buildBusinessListPage();
    }
  }

  Widget _buildBusinessListPage() {
    final businessState = ref.watch(businessViewModelProvider);

    if (businessState.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primaryOrange),
      );
    }

    if (businessState.isError && businessState.message != null) {
      return _buildErrorState(businessState.message!);
    }

    if (businessState.businesses.isEmpty) {
      return _buildEmptyState(
        Icons.business_center_outlined,
        'No businesses found',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(businessViewModelProvider.notifier).getAllBusinesses();
      },
      color: AppColors.primaryOrange,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: businessState.businesses.length,
        itemBuilder: (context, index) {
          final business = businessState.businesses[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: BusinessCard(
              business: business,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BusinessDetailScreen(businessId: business.id ?? ''),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFavoritesPage() {
    return _buildPlaceholderPage(
      'assets/icons/favorite.png',
      'Your Favorites',
      'Save your favorite pets and businesses to easily find them later.',
    );
  }

  Widget _buildCompatibilityPage() {
    return _buildPlaceholderPage(
      'assets/icons/compatibility.png',
      'Pet Compatibility',
      'Find the perfect pet match based on your lifestyle and preferences.',
      showButton: true,
    );
  }

  Widget _buildPlaceholderPage(
    String iconPath,
    String title,
    String subtitle, {
    bool showButton = false,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryOrange.withOpacity(0.2),
                width: 5,
              ),
            ),
            child: Center(
              child: Image.asset(
                iconPath,
                height: 60,
                color: AppColors.primaryOrange,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppStyles.headline3.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppStyles.body.copyWith(
                fontSize: 16,
                color: AppColors.textLightGrey.withOpacity(0.9),
                height: 1.4,
              ),
            ),
          ),
          if (showButton) ...[
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
              child: Text('Start Matching', style: AppStyles.button),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.textLightGrey),
          const SizedBox(height: 16),
          Text(message, style: AppStyles.body, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                ref.read(businessViewModelProvider.notifier).getAllBusinesses(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
            ),
            child: Text('Retry', style: AppStyles.button),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.textLightGrey),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppStyles.headline3.copyWith(color: AppColors.textLightGrey),
          ),
        ],
      ),
    );
  }
}
