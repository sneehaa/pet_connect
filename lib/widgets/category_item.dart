import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryItem extends StatelessWidget {
  final String label;
  final String imagePath; // Path to your asset
  final bool isSelected;

  const CategoryItem({
    super.key,
    required this.label,
    required this.imagePath,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 25), 
      child: Column(
        children: [
          Container(
            width: 75,
            height: 120,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFF987C) : Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: isSelected ? Colors.transparent : Colors.grey.shade100,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.pets),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                Text(
                  label,
                  style: GoogleFonts.alice(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: isSelected ? Colors.white : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
