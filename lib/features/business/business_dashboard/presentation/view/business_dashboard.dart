import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/business/business_dashboard/presentation/view/%20pets_list.dart';
import 'package:pet_connect/features/business/business_dashboard/presentation/view/adoption_requests_list.dart';
import 'package:pet_connect/features/business/business_profile/presentation/view/business_profile.dart';

class BusinessDashboardScreen extends StatefulWidget {
  const BusinessDashboardScreen({super.key});

  @override
  State<BusinessDashboardScreen> createState() =>
      _BusinessDashboardScreenState();
}

class _BusinessDashboardScreenState extends State<BusinessDashboardScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _screenData = [
    {
      'title': 'Dashboard',
      'icon_asset': 'assets/icons/app.png',
      'subtitle': 'Overview of your business',
    },
    {
      'title': 'My Pets',
      'icon_asset': 'assets/icons/paw.png',
      'subtitle': 'Manage your pet listings',
    },
    {
      'title': 'Adoption History',
      'icon_asset': 'assets/icons/requests.png',
      'subtitle': 'Track all adoption requests',
    },
    {
      'title': 'Profile',
      'icon_asset': 'assets/icons/user.png',
      'subtitle': 'Business settings & info',
    },
  ];

  final List<String> _navAssetPaths = [
    'assets/icons/app.png',
    'assets/icons/paw.png',
    'assets/icons/requests.png',
    'assets/icons/user.png',
  ];
  final List<String> _navLabels = ['Home', 'Pets', 'History', 'Profile'];

  final Color _textDeepDark = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildCustomAppBar(),
          Expanded(
            child: Container(
              color: AppColors.background,
              child: _getSelectedPage(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildCustomAppBar() {
    final screenData = _screenData[_selectedIndex];
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
                    'Pet Business',
                    style: AppStyles.headline3.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _textDeepDark,
                    ),
                  ),
                ],
              ),
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: AppColors.primaryWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/icons/bell.png',
                        height: 26,
                        color: _textDeepDark,
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.errorRed,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryWhite,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                        color: _textDeepDark,
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
                  _screenData[0]['icon_asset'] as String,
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
                color: _textDeepDark,
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

  Widget _buildBottomNavBar() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Container(
        height: 85,
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryOrange.withOpacity(0.2),
              blurRadius: 25,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (index) {
            return Expanded(child: _buildNavItem(index));
          }),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 75,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              width: isSelected ? 56 : 50,
              height: isSelected ? 56 : 50,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryOrange.withOpacity(0.15)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    _navAssetPaths[index],
                    height: 26,
                    color: isSelected
                        ? AppColors.primaryOrange
                        : AppColors.textDarkGrey,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _navLabels[index],
              style: AppStyles.small.copyWith(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primaryOrange
                    : AppColors.textDarkGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
