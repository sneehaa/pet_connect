import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_connect/config/themes/app_colors.dart';

class PetListHeader extends StatelessWidget {
  final int petCount;
  final VoidCallback onFilterPressed;

  const PetListHeader({
    super.key,
    required this.petCount,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(
            25,
          ), // Increased radius for better visual flow
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Removed 'My Pets' title as requested. Displaying only the count.
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pet Listings',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors
                      .textGrey, // Using AppColors.textGrey for primary text
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$petCount ${petCount == 1 ? 'pet' : 'pets'} active',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textGrey.withOpacity(
                    0.7,
                  ), // Slightly lighter textGrey for subtitle
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          // Filter Button
          _buildFilterButton(),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.primaryOrange, // Use primary color for background
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onFilterPressed,
        icon: const Icon(
          Icons.filter_list,
          color: AppColors.primaryWhite,
          size: 22,
        ),
        padding: EdgeInsets.zero,
        splashRadius: 20,
      ),
    );
  }
}
