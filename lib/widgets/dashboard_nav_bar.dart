import 'package:flutter/material.dart';

class BusinessCustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabChanged;

  const BusinessCustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  State<BusinessCustomBottomNavBar> createState() =>
      _BusinessCustomBottomNavBarState();
}

class _BusinessCustomBottomNavBarState
    extends State<BusinessCustomBottomNavBar> {
  final List<String> icons = [
    'assets/icons/home.png',
    'assets/icons/paw.png',
    'assets/icons/requests.png',
    'assets/icons/user.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
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
          bool isSelected = widget.currentIndex == index;
          return GestureDetector(
            onTap: () => widget.onTabChanged(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFF987C)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  icons[index],
                  width: 26,
                  height: 26,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
