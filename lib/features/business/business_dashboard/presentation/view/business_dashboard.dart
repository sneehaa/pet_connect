import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
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

  final List<Widget> _pages = [
    const PetListScreen(),
    const AdoptionRequestsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: AppColors.primaryWhite,
        selectedItemColor: AppColors.primaryOrange,
        unselectedItemColor: AppColors.textLightGrey,
        selectedLabelStyle: AppStyles.small.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppStyles.small,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'My Pets'),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Requests',
          ),
        ],
      ),
    );
  }
}
