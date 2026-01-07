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
  String? _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.petId != null) {
        ref
            .read(adoptionViewModelProvider.notifier)
            .getPetAdoptions(widget.petId!);
      } else {
        // Load all adoption requests for business
        ref.read(adoptionViewModelProvider.notifier).getAdoptionHistory();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AdoptionState>(adoptionViewModelProvider, (previous, next) {
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
      appBar: AppBar(
        backgroundColor: AppColors.primaryWhite,
        elevation: 0,
        title: Text(
          widget.petId != null
              ? 'Pet Adoption Requests'
              : 'All Adoption Requests',
          style: AppStyles.headline2.copyWith(color: AppColors.textDarkGrey),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: AppColors.textDarkGrey),
        ),
        actions: [
          if (widget.petId == null)
            PopupMenuButton<String>(
              onSelected: (value) {
                setState(() {
                  _selectedFilter = value;
                });
              },
              icon: Icon(Icons.filter_list, color: AppColors.primaryOrange),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'all', child: Text('All Requests')),
                const PopupMenuItem(value: 'pending', child: Text('Pending')),
                const PopupMenuItem(value: 'approved', child: Text('Approved')),
                const PopupMenuItem(value: 'rejected', child: Text('Rejected')),
              ],
            ),
        ],
      ),
      body: state.status == AdoptionStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : state.status == AdoptionStatus.error
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
                        ref
                            .read(adoptionViewModelProvider.notifier)
                            .getAdoptionHistory();
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
                  await ref
                      .read(adoptionViewModelProvider.notifier)
                      .getAdoptionHistory();
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

  List<AdoptionEntity> _filterAdoptions(List<AdoptionEntity> adoptions) {
    if (_selectedFilter == 'all') return adoptions;
    return adoptions
        .where((adoption) => adoption.status == _selectedFilter)
        .toList();
  }

  Widget _buildAdoptionCard(AdoptionEntity adoption, BuildContext context) {
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
                Text(
                  'Request #${adoption.id?.substring(0, 8) ?? 'N/A'}',
                  style: AppStyles.headline3.copyWith(
                    color: _getStatusColor(adoption.status),
                  ),
                ),
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
                      Icons.person,
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
                // Message
                if (adoption.message != null && adoption.message!.isNotEmpty)
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
                        adoption.message!,
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
                            _updateAdoptionStatus(
                              adoption.id!,
                              'rejected',
                              context,
                            );
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return AppColors.errorRed;
      default:
        return AppColors.textLightGrey;
    }
  }

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
                    : 'Are you sure you want to reject this adoption request?',
                style: AppStyles.body,
              ),
              const SizedBox(height: 10),
              Text(
                status == 'approved'
                    ? 'The user will be notified and can proceed with adoption.'
                    : 'This action cannot be undone. The user will be notified.',
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
                Navigator.pop(context);
                ref
                    .read(adoptionViewModelProvider.notifier)
                    .updateAdoptionStatus(adoptionId, status);
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
}
