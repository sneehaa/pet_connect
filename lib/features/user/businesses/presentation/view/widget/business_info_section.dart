import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/businesses/domain/entity/business_entity.dart';

import 'info_row_widget.dart';

class BusinessInfoSection extends StatelessWidget {
  final BusinessEntity business;

  const BusinessInfoSection({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Business Information',
            style: AppStyles.headline3.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          if (business.address != null) ...[
            InfoRowWidget(
              icon: Icons.location_on,
              label: 'Address',
              value: business.address!,
            ),
            const SizedBox(height: 16),
          ],
          InfoRowWidget(
            icon: Icons.business_center,
            label: 'Role',
            value: business.role,
          ),
        ],
      ),
    );
  }
}
