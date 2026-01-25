import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/core/utils/snackbar_utils.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/entity/adoption_entity.dart';
import 'package:pet_connect/features/business/business_dashboard/presentation/state/adoption_state.dart';
import 'package:pet_connect/features/business/business_dashboard/presentation/viewmodel/adoption_view_model.dart';

class AdoptionRequestsScreen extends ConsumerStatefulWidget {
  final String? petId;
  const AdoptionRequestsScreen({super.key, this.petId});

  @override
  ConsumerState<AdoptionRequestsScreen> createState() =>
      _AdoptionRequestsScreenState();
}

class _AdoptionRequestsScreenState
    extends ConsumerState<AdoptionRequestsScreen> {
  final String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.petId != null) {
        ref
            .read(adoptionViewModelProvider.notifier)
            .getPetAdoptions(widget.petId!);
      } else {
        ref.read(adoptionViewModelProvider.notifier).getBusinessAdoptions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<BusinessAdoptionState>(adoptionViewModelProvider, (
      previous,
      next,
    ) {
      if (next.message != null) {
        showSnackBar(
          context: context,
          message: next.message!,
          isSuccess:
              !next.message!.contains('Failed') &&
              !next.message!.contains('error'),
        );
      }
    });

    final state = ref.watch(adoptionViewModelProvider);
    final filteredAdoptions = _filterAdoptions(state.adoptions);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: state.status == BusinessAdoptionStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : state.status == BusinessAdoptionStatus.error
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppColors.errorRed,
                    size: 60,
                  ),
                  const SizedBox(height: 20),
                  Text('Failed to load requests', style: AppStyles.headline3),
                  Text(
                    state.message ?? 'Please try again',
                    style: AppStyles.subtitle,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.petId != null) {
                        ref
                            .read(adoptionViewModelProvider.notifier)
                            .getPetAdoptions(widget.petId!);
                      } else {
                        // FIXED: Call getBusinessAdoptions
                        ref
                            .read(adoptionViewModelProvider.notifier)
                            .getBusinessAdoptions();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Retry', style: AppStyles.button),
                  ),
                ],
              ),
            )
          : filteredAdoptions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, color: AppColors.primaryOrange, size: 80),
                  const SizedBox(height: 20),
                  Text('No Adoption Requests', style: AppStyles.headline3),
                  Text(
                    widget.petId != null
                        ? 'No one has applied for this pet yet'
                        : 'No adoption requests found',
                    style: AppStyles.subtitle,
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                if (widget.petId != null) {
                  await ref
                      .read(adoptionViewModelProvider.notifier)
                      .getPetAdoptions(widget.petId!);
                } else {
                  // FIXED: Call getBusinessAdoptions
                  await ref
                      .read(adoptionViewModelProvider.notifier)
                      .getBusinessAdoptions();
                }
              },
              backgroundColor: AppColors.background,
              color: AppColors.primaryOrange,
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: filteredAdoptions.length,
                itemBuilder: (context, index) {
                  final adoption = filteredAdoptions[index];
                  return _buildAdoptionCard(adoption, context);
                },
              ),
            ),
    );
  }

  List<BusinessAdoptionEntity> _filterAdoptions(
    List<BusinessAdoptionEntity> adoptions,
  ) {
    if (_selectedFilter == 'all') return adoptions;
    return adoptions
        .where((adoption) => adoption.status == _selectedFilter)
        .toList();
  }

  Widget _buildAdoptionCard(
    BusinessAdoptionEntity adoption,
    BuildContext context,
  ) {
    final appDetails = adoption.applicationDetails;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status
          // Replace the header Container (around line 170-210) with this fixed version:
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _getStatusColor(adoption.status).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Wrap the text in Flexible to prevent overflow
                Flexible(
                  child: Text(
                    'Request #${adoption.id?.substring(0, 8) ?? 'N/A'}',
                    style: AppStyles.headline3.copyWith(
                      color: _getStatusColor(adoption.status),
                    ),
                    overflow: TextOverflow
                        .ellipsis, // Add ellipsis if text is too long
                  ),
                ),
                const SizedBox(width: 8), // Add spacing between elements
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(adoption.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    adoption.status.toUpperCase(),
                    style: GoogleFonts.alice(
                      color: AppColors.primaryWhite,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Request Details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Applicant Name
                if (appDetails != null)
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: AppColors.textLightGrey,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Applicant: ${appDetails.fullName}',
                          style: AppStyles.body,
                        ),
                      ),
                    ],
                  ),
                if (appDetails != null) const SizedBox(height: 10),
                // Pet ID
                Row(
                  children: [
                    Icon(Icons.pets, color: AppColors.textLightGrey, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Pet ID: ${adoption.petId}',
                        style: AppStyles.body,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // User ID
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: AppColors.textLightGrey,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'User ID: ${adoption.userId}',
                        style: AppStyles.body,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Phone Number
                if (appDetails != null)
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: AppColors.textLightGrey,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Phone: ${appDetails.phoneNumber}',
                          style: AppStyles.body,
                        ),
                      ),
                    ],
                  ),
                if (appDetails != null) const SizedBox(height: 10),
                // Address
                if (appDetails != null)
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.textLightGrey,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Address: ${appDetails.address}',
                          style: AppStyles.body,
                        ),
                      ),
                    ],
                  ),
                if (appDetails != null) const SizedBox(height: 10),
                // Date
                if (adoption.createdAt != null)
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: AppColors.textLightGrey,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('MMM dd, yyyy').format(adoption.createdAt!),
                        style: AppStyles.small,
                      ),
                    ],
                  ),
                const SizedBox(height: 15),
                // Additional application details
                if (appDetails != null) ...[
                  _buildDetailRow('Home Type:', appDetails.homeType),
                  _buildDetailRow('Employment:', appDetails.employmentStatus),
                  if (appDetails.previousPetExperience != null)
                    _buildDetailRow(
                      'Experience:',
                      appDetails.previousPetExperience!,
                    ),
                  _buildDetailRow(
                    'Other Pets:',
                    appDetails.hasOtherPets ? 'Yes' : 'No',
                  ),
                  if (appDetails.hasOtherPets)
                    _buildDetailRow(
                      'Other Pets Details:',
                      appDetails.otherPetsDetails,
                    ),
                ],
                // Message
                if (appDetails != null &&
                    appDetails.message != null &&
                    appDetails.message!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Message:',
                        style: AppStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        appDetails.message!,
                        style: AppStyles.small.copyWith(
                          color: AppColors.textDarkGrey,
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                // Action Buttons
                if (adoption.status == 'pending')
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _updateAdoptionStatus(
                              adoption.id!,
                              'approved',
                              context,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: Text(
                            'Approve',
                            style: AppStyles.button.copyWith(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showRejectReasonDialog(adoption.id!, context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.errorRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: Text(
                            'Reject',
                            style: AppStyles.button.copyWith(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (adoption.status != 'pending')
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGrey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          adoption.status == 'approved'
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: adoption.status == 'approved'
                              ? Colors.green
                              : AppColors.errorRed,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            adoption.status == 'approved'
                                ? 'This request has been approved'
                                : 'This request has been rejected',
                            style: AppStyles.small.copyWith(
                              color: adoption.status == 'approved'
                                  ? Colors.green
                                  : AppColors.errorRed,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppStyles.small.copyWith(
              color: AppColors.textDarkGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: AppStyles.small.copyWith(color: AppColors.textDarkGrey),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return AppColors.errorRed;
      case 'payment_pending':
        return Colors.blue;
      case 'completed':
        return Colors.purple;
      default:
        return AppColors.textLightGrey;
    }
  }

  // FIXED: Renamed to _updateAdoptionStatus
  void _updateAdoptionStatus(
    String adoptionId,
    String status,
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                status == 'approved' ? Icons.check_circle : Icons.warning,
                color: status == 'approved' ? Colors.green : AppColors.errorRed,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                status == 'approved' ? 'Approve Request' : 'Reject Request',
                style: AppStyles.headline3,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status == 'approved'
                    ? 'Are you sure you want to approve this adoption request?'
                    : 'Please provide a reason for rejection:',
                style: AppStyles.body,
              ),
              const SizedBox(height: 10),
              if (status == 'rejected')
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter rejection reason',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    // Store the reason
                  },
                ),
              if (status == 'approved')
                Text(
                  'The user will be notified and can proceed with adoption.',
                  style: AppStyles.small.copyWith(
                    color: AppColors.textLightGrey,
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppStyles.button.copyWith(color: AppColors.textDarkGrey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (status == 'approved') {
                  ref
                      .read(adoptionViewModelProvider.notifier)
                      .approveAdoption(adoptionId);
                } else {
                  // For rejection, we'll handle it in the separate dialog
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: status == 'approved'
                    ? Colors.green
                    : AppColors.errorRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                status == 'approved' ? 'Approve' : 'Reject',
                style: AppStyles.button,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showRejectReasonDialog(String adoptionId, BuildContext context) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.warning, color: AppColors.errorRed, size: 28),
              const SizedBox(width: 12),
              Text('Reject Request', style: AppStyles.headline3),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please provide a reason for rejection:',
                style: AppStyles.body,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  hintText: 'Enter rejection reason',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              Text(
                'This action cannot be undone. The user will be notified.',
                style: AppStyles.small.copyWith(color: AppColors.textLightGrey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppStyles.button.copyWith(color: AppColors.textDarkGrey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final reason = reasonController.text.trim();
                if (reason.isEmpty) {
                  showSnackBar(
                    context: context,
                    message: 'Please provide a rejection reason',
                    isSuccess: false,
                  );
                  return;
                }

                Navigator.pop(context);
                ref
                    .read(adoptionViewModelProvider.notifier)
                    .rejectAdoption(adoptionId, reason);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Reject', style: AppStyles.button),
            ),
          ],
        );
      },
    );
  }
}
