import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/business/business_dashboard/presentation/view/%20pets_list.dart';
import 'package:pet_connect/features/business/business_dashboard/presentation/view/adoption_requests_list.dart';
import 'package:pet_connect/features/business/business_dashboard/presentation/viewmodel/dashboard_view_model.dart';
import 'package:pet_connect/features/business/business_payment/presentation/view/screens/business_payment_dashboard_screen.dart';
import 'package:pet_connect/features/business/business_profile/presentation/view/business_profile.dart';
import 'package:pet_connect/features/business/business_profile/presentation/viewmodel/business_profile_viewmodel.dart';
import 'package:pet_connect/features/notifications/presentation/view/business_notifications_screen.dart';
import 'package:pet_connect/features/notifications/presentation/viewmodel/notification_view_model.dart';
import 'package:pet_connect/features/user/home/widgets/custom_appbar.dart';
import 'package:pet_connect/utils/login_choice.dart';
import 'package:pet_connect/widgets/dashboard_nav_bar.dart';

class BusinessDashboardScreen extends ConsumerStatefulWidget {
  const BusinessDashboardScreen({super.key});

  @override
  ConsumerState<BusinessDashboardScreen> createState() =>
      _BusinessDashboardScreenState();
}

class _BusinessDashboardScreenState
    extends ConsumerState<BusinessDashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(notificationViewModelProvider.notifier)
          .getBusinessNotifications();
    });
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

              final profileState = ref.watch(businessProfileViewModelProvider);

              String userName = 'Pet Business';

              if (profileState.profile != null) {
                userName = profileState.profile!.businessName;
              }

              return CustomAppBar(
                selectedIndex: _selectedIndex,
                userName: userName,
                unreadNotificationCount: unreadCount,
                onNotificationTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BusinessNotificationsScreen(),
                    ),
                  ).then((_) {
                    ref
                        .read(notificationViewModelProvider.notifier)
                        .getBusinessNotifications();
                  });
                },
                onWalletTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const BusinessPaymentDashboardScreen(),
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
      bottomNavigationBar: BusinessCustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTabChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
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
                await ref.read(dashboardViewModelProvider.notifier).logout();

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

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return const Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: PetListScreen(),
        );
      case 2:
        return const Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: AdoptionRequestsScreen(),
        );
      case 3:
        return const BusinessProfileScreen();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Center(
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
                  'assets/icons/home.png',
                  height: 60,
                  color: AppColors.primaryOrange,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Dashboard Overview',
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
                'Monitor your pet listings, track adoption progress, and view key business metrics here.',
                textAlign: TextAlign.center,
                style: AppStyles.body.copyWith(
                  fontSize: 16,
                  color: AppColors.textLightGrey.withOpacity(0.9),
                  height: 1.4,
                ),
              ),
            ),
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
              child: Text(
                'View Analytics (Soon)',
                style: AppStyles.button.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
