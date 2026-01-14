import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/entity/pet_entity.dart';

class DeleteConfirmationDialog extends ConsumerWidget {
  final PetEntity pet;
  final VoidCallback onDelete;

  const DeleteConfirmationDialog({
    super.key,
    required this.pet,
    required this.onDelete,
  });

  TextStyle _headlineStyle() => GoogleFonts.alice(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textGrey,
  );

  TextStyle _bodyStyle() => GoogleFonts.alice(
    fontSize: 14,
    color: AppColors.textLightGrey,
    height: 1.5,
  );

  TextStyle _buttonTextStyle({required Color color}) => GoogleFonts.alice(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: color,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      elevation: 15,
      child: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.red.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.delete_forever_outlined,
                color: Colors.red,
                size: 35,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Delete ${pet.name}?',
              style: _headlineStyle().copyWith(
                fontSize: 22,
                color: AppColors.textDarkGrey,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This action cannot be undone. All adoption requests for this pet will also be deleted.',
              textAlign: TextAlign.center,
              style: _bodyStyle(),
            ),
            const SizedBox(height: 30),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.backgroundGrey, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'Cancel',
                style: _buttonTextStyle(color: AppColors.textDarkGrey),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onDelete();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorRed,
                elevation: 5,
                shadowColor: AppColors.errorRed.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'Delete',
                style: _buttonTextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
