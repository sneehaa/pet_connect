import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/businesses/presentation/state/business_state.dart';
import 'package:pet_connect/features/user/businesses/presentation/view/widget/business_card.dart';
import 'package:pet_connect/features/user/businesses/presentation/viewmodel/business_viewmodel.dart';
import 'package:pet_connect/widgets/custom_navbar.dart';

class Homescreen extends ConsumerStatefulWidget {
  const Homescreen({super.key});

  @override
  ConsumerState<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load businesses when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(businessViewModelProvider.notifier).getAllBusinesses();
    });
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onBusinessTap(String businessId) {
    ref.read(businessViewModelProvider.notifier).getBusinessById(businessId);
  }

  @override
  Widget build(BuildContext context) {
    final businessState = ref.watch(businessViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Pet Businesses',
          style: AppStyles.headline2.copyWith(color: AppColors.textDarkGrey),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.location_on, color: AppColors.primaryOrange),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {
              // Navigate to search screen
            },
          ),
        ],
      ),
      body: _buildBody(businessState),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTabChanged: _onTabChanged,
      ),
    );
  }

  Widget _buildBody(BusinessState state) {
    if (state.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primaryOrange),
      );
    }

    if (state.isError && state.message != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.textLightGrey),
            const SizedBox(height: 16),
            Text(
              state.message!,
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
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.businesses.isEmpty) {
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
        padding: const EdgeInsets.all(16),
        itemCount: state.businesses.length,
        itemBuilder: (context, index) {
          final business = state.businesses[index];
          return BusinessCard(
            business: business,
            onTap: () => _onBusinessTap(business.id ?? ''),
          );
        },
      ),
    );
  }
}
