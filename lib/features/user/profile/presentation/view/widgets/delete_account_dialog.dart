import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';

class DeleteAccountDialog extends StatefulWidget {
  final VoidCallback onDeleteAccount;

  const DeleteAccountDialog({super.key, required this.onDeleteAccount});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  bool _isLoading = false;
  bool _confirmDelete = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Warning Icon
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              'Delete Your Account',
              textAlign: TextAlign.center,
              style: AppStyles.headline2.copyWith(
                fontSize: 22,
                color: Colors.red,
              ),
            ),

            const SizedBox(height: 16),

            // Warning Message
            Text(
              'This action cannot be undone. All your data will be permanently deleted, including:',
              textAlign: TextAlign.center,
              style: AppStyles.body.copyWith(color: AppColors.textDarkGrey),
            ),

            const SizedBox(height: 16),

            // Consequences List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildConsequence('Your profile information'),
                  _buildConsequence('Adoption applications'),
                  _buildConsequence('Payment history'),
                  _buildConsequence('Favorites and preferences'),
                  _buildConsequence('All associated data'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Confirmation Checkbox
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: _confirmDelete,
                    onChanged: (value) {
                      setState(() {
                        _confirmDelete = value ?? false;
                      });
                    },
                    activeColor: Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'I understand that this action is permanent and cannot be undone',
                      style: AppStyles.small.copyWith(
                        color: Colors.red.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: AppColors.textLightGrey),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppStyles.body.copyWith(
                        color: AppColors.textDarkGrey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (!_confirmDelete || _isLoading)
                        ? null
                        : () {
                            _deleteAccount();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Delete Account',
                            style: AppStyles.button.copyWith(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Alternative Action
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Navigate to contact support or deactivate instead
                },
                child: Text(
                  'Contact Support Instead',
                  style: AppStyles.small.copyWith(
                    color: AppColors.primaryOrange,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsequence(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.remove, size: 16, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppStyles.body.copyWith(color: AppColors.textDarkGrey),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 800), () {
      widget.onDeleteAccount();

      setState(() {
        _isLoading = false;
      });

      // Close dialog after action
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    });
  }
}
