import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/features/business/business_dashboard/presentation/view/%20pets_list.dart';
import 'package:pet_connect/features/business/business_dashboard/presentation/view/adoption_requests_list.dart';

class BusinessDashboardScreen extends StatefulWidget {
  const BusinessDashboardScreen({super.key});

  @override
  State<BusinessDashboardScreen> createState() =>
      _BusinessDashboardScreenState();
}

class _BusinessDashboardScreenState extends State<BusinessDashboardScreen> {
  int _selectedIndex = 0;

  // Define screen titles and icons (using asset paths for the header icon)
  final List<Map<String, dynamic>> _screenData = [
    {
      'title': 'Dashboard',
      'icon': 'assets/icons/home.png',
      'subtitle': 'Overview of your business',
    },
    {
      'title': 'My Pets',
      'icon': 'assets/icons/paw.png',
      'subtitle': 'Manage your pet listings',
    },
    {
      'title': 'Adoption History',
      'icon': 'assets/icons/requests.png',
      'subtitle': 'Track all adoption requests',
    },
    {
      'title': 'Profile',
      'icon': 'assets/icons/business.png',
      'subtitle': 'Business settings & info',
    },
  ];

  // Asset icon paths for bottom nav
  final List<String> _navIcons = [
    'assets/icons/home.png',
    'assets/icons/paw.png',
    'assets/icons/requests.png',
    'assets/icons/business.png',
  ];

  final List<String> _navLabels = ['Home', 'Pets', 'History', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Custom App Bar
                _buildCustomAppBar(),
                // Content
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      child: _getSelectedPage(),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomNavBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    final screenData = _screenData[_selectedIndex];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Profile/Menu Button
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryOrange.withOpacity(0.1),
                      AppColors.primaryOrange.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.menu_rounded,
                  color: AppColors.primaryOrange,
                  size: 24,
                ),
              ),
              // Notification Button
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryOrange.withOpacity(0.1),
                      AppColors.primaryOrange.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.notifications_outlined,
                        color: AppColors.primaryOrange,
                        size: 24,
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: Colors.red,
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
          const SizedBox(height: 20),
          // Title and Icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryOrange,
                      AppColors.primaryOrange.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryOrange.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.asset(
                  screenData['icon'],
                  width: 28,
                  height: 28,
                  color: AppColors.primaryWhite,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      screenData['title'],
                      style: GoogleFonts.alice(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDarkGrey,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      screenData['subtitle'],
                      style: GoogleFonts.alice(
                        fontSize: 14,
                        color: AppColors.textLightGrey,
                        fontWeight: FontWeight.w400,
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
        return const PetListScreen();
      case 2:
        return const AdoptionRequestsScreen();
      case 3:
        return _buildProfilePage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return Center(
      child: Text(
        'Home Dashboard',
        style: GoogleFonts.alice(fontSize: 20, color: AppColors.textDarkGrey),
      ),
    );
  }

  Widget _buildProfilePage() {
    return Center(
      child: Text(
        'Business Profile',
        style: GoogleFonts.alice(fontSize: 20, color: AppColors.textDarkGrey),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 25),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      height: 68,
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (index) {
          return _buildNavItem(index);
        }),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryOrange.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              _navIcons[index],
              width: 24,
              height: 24,
              color: isSelected
                  ? AppColors.primaryOrange
                  : AppColors.textLightGrey,
            ),
            const SizedBox(height: 2),
            Text(
              _navLabels[index],
              style: GoogleFonts.alice(
                fontSize: 11,
                color: isSelected
                    ? AppColors.primaryOrange
                    : AppColors.textLightGrey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
