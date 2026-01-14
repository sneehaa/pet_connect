import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/businesses/presentation/view/business_detail_screen.dart';
import 'package:pet_connect/features/user/businesses/presentation/view/widget/business_card.dart';
import 'package:pet_connect/features/user/businesses/presentation/viewmodel/business_viewmodel.dart';
import 'package:pet_connect/features/user/home/widgets/custom_appbar.dart';
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
    });
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onBusinessTap(String businessId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BusinessDetailScreen(businessId: businessId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          CustomAppBar(
            selectedIndex: _selectedIndex,
            userName: 'Pet Lover',
            onNotificationTap: () {
              debugPrint('Notification tapped');
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

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildBusinessListPage();
      case 1:
        return _buildFavoritesPage();
      case 2:
        return _buildCompatibilityPage();
      case 3:
        return _buildProfilePage();
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.textLightGrey),
            const SizedBox(height: 16),
            Text(
              businessState.message!,
              style: AppStyles.body.copyWith(color: AppColors.textLightGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(businessViewModelProvider.notifier).getAllBusinesses();
              },
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
                'Retry',
                style: AppStyles.button.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryWhite,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (businessState.businesses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business_center_outlined,
              size: 64,
              color: AppColors.textLightGrey,
            ),
            const SizedBox(height: 16),
            Text(
              'No businesses found',
              style: AppStyles.headline3.copyWith(
                color: AppColors.textLightGrey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(businessViewModelProvider.notifier).getAllBusinesses();
      },
      color: AppColors.primaryOrange,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        itemCount: businessState.businesses.length,
        itemBuilder: (context, index) {
          final business = businessState.businesses[index];
          return BusinessCard(
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
          );
        },
      ),
    );
  }

  Widget _buildFavoritesPage() {
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
                'assets/icons/favorite.png',
                height: 60,
                color: AppColors.primaryOrange,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Your Favorites',
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
              'Save your favorite pets and businesses to easily find them later.',
              textAlign: TextAlign.center,
              style: AppStyles.body.copyWith(
                fontSize: 16,
                color: AppColors.textLightGrey.withOpacity(0.9),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompatibilityPage() {
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
                'assets/icons/compatibility.png',
                height: 60,
                color: AppColors.primaryOrange,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Pet Compatibility',
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
              'Find the perfect pet match based on your lifestyle and preferences.',
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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: Text(
              'Start Matching',
              style: AppStyles.button.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
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
                'assets/icons/user.png',
                height: 60,
                color: AppColors.primaryOrange,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Your Profile',
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
              'Manage your account settings and preferences here.',
              textAlign: TextAlign.center,
              style: AppStyles.body.copyWith(
                fontSize: 16,
                color: AppColors.textLightGrey.withOpacity(0.9),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
