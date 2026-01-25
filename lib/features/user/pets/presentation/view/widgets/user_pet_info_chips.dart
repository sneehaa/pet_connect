import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/pets/domain/entity/pet_entity.dart';

class UserPetInfoChips extends StatelessWidget {
  final UserPetEntity pet;

  const UserPetInfoChips({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _buildInfoChip(
          icon: Icons.cake_outlined,
          text: '${pet.age} ${pet.age == 1 ? 'month' : 'months'}',
          color: AppColors.primaryOrange,
        ),
        _buildInfoChip(
          icon: pet.gender.toLowerCase() == 'male' ? Icons.male : Icons.female,
          text: pet.gender,
          color: pet.gender.toLowerCase() == 'male'
              ? Colors.blue
              : Colors.pink.shade400,
        ),
        if (pet.vaccinated)
          _buildInfoChip(
            icon: Icons.verified_outlined,
            text: 'Vaccinated',
            color: AppColors.successGreen,
          ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.08)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppStyles.small.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
