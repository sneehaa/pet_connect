import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';

class BusinessBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BusinessBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<BusinessBottomNavBar> createState() => _BusinessBottomNavBarState();
}

class _BusinessBottomNavBarState extends State<BusinessBottomNavBar> {
  // Business-specific icons (make sure to add these to your assets/icons folder)
  final List<String> icons = [
    'assets/icons/paw.png',
    'assets/icons/requests.png',
    'assets/icons/plus.png',
    'assets/icons/business.png', // Business Profile
  ];

  final List<String> labels = [
    'Pets',
    'Requests',
    'Add',
    'Analytics',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 25),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(icons.length, (index) {
          bool isSelected = widget.selectedIndex == index;
          bool isCenterItem = index == 2; // The "Add" button in center

          if (isCenterItem) {
            return _buildCenterButton(context, index);
          }

          return _buildNavItem(index, isSelected);
        }),
      ),
    );
  }

  Widget _buildNavItem(int index, bool isSelected) {
    return GestureDetector(
      onTap: () => widget.onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryOrange : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icons[index],
              width: 24,
              height: 24,
              color: isSelected
                  ? AppColors.primaryWhite
                  : AppColors.textDarkGrey,
            ),
            const SizedBox(height: 4),
            Text(
              labels[index],
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? AppColors.primaryWhite
                    : AppColors.textLightGrey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => widget.onItemTapped(index),
      child: Container(
        width: 70,
        height: 70,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryOrange,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryOrange.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppColors.primaryWhite, size: 28),
            const SizedBox(height: 2),
            Text(
              'Add',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.primaryWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
