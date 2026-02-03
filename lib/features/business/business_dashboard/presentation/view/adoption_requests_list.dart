import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      _fetchData();
    });
  }

  void _fetchData() {
    if (widget.petId != null) {
      ref
          .read(adoptionViewModelProvider.notifier)
          .getPetAdoptions(widget.petId!);
    } else {
      ref.read(adoptionViewModelProvider.notifier).getBusinessAdoptions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adoptionViewModelProvider);

    ref.listen<BusinessAdoptionState>(adoptionViewModelProvider, (
      previous,
      next,
    ) {
      if (previous?.status == BusinessAdoptionStatus.loading &&
          next.status != BusinessAdoptionStatus.loading) {
        if (next.message != null && next.message!.isNotEmpty) {
          showSnackBar(
            context: context,
            message: next.message!,
            isSuccess: next.status != BusinessAdoptionStatus.error,
          );

          if (next.status == BusinessAdoptionStatus.loaded &&
              next.message!.toLowerCase().contains('success')) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) Navigator.pop(context);
            });
          }
          ref.read(adoptionViewModelProvider.notifier).clearMessage();
        }
      }
    });

    final filteredAdoptions = _filterAdoptions(state.adoptions);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: widget.petId != null
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('Requests', style: AppStyles.headline3),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.textBlack,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            )
          : null,
      body: state.status == BusinessAdoptionStatus.loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryOrange),
            )
          : state.status == BusinessAdoptionStatus.error
          ? _buildErrorState(state.message)
          : filteredAdoptions.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: () async => _fetchData(),
              color: AppColors.primaryOrange,
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: filteredAdoptions.length,
                itemBuilder: (context, index) =>
                    _buildAdoptionCard(filteredAdoptions[index], context),
              ),
            ),
    );
  }

  Widget _buildAdoptionCard(
    BusinessAdoptionEntity adoption,
    BuildContext context,
  ) {
    final appDetails = adoption.applicationDetails;
    final bool isPending = adoption.status.toLowerCase() == 'pending';
    final bool isApproved =
        adoption.status.toLowerCase() == 'approved' ||
        adoption.status.toLowerCase() == 'completed' ||
        adoption.status.toLowerCase() == 'payment_pending';

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
          Container(
            padding: const EdgeInsets.all(15),
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
                Flexible(
                  child: Text(
                    'Request #${adoption.id?.substring(0, 8).toUpperCase() ?? 'N/A'}',
                    style: AppStyles.body.copyWith(
                      color: _getStatusColor(adoption.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(adoption.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    adoption.status.toUpperCase(),
                    style: AppStyles.small.copyWith(
                      color: AppColors.primaryWhite,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(Icons.person, 'Applicant', appDetails?.fullName),
                _buildInfoRow(Icons.pets, 'Pet ID', adoption.petId),
                _buildInfoRow(Icons.phone, 'Phone', appDetails?.phoneNumber),
                _buildInfoRow(
                  Icons.location_on,
                  'Address',
                  appDetails?.address,
                ),
                const Divider(height: 30),
                if (appDetails != null) ...[
                  _buildDetailRow('Home Type:', appDetails.homeType),
                  _buildDetailRow('Employment:', appDetails.employmentStatus),
                  _buildDetailRow(
                    'Other Pets:',
                    appDetails.hasOtherPets ? 'Yes' : 'No',
                  ),
                ],
                const SizedBox(height: 20),
                if (isPending)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _updateAdoptionStatus(
                            adoption.id!,
                            'approved',
                            context,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.successGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('Approve', style: AppStyles.button),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              _showRejectReasonDialog(adoption.id!, context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.errorRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('Reject', style: AppStyles.button),
                        ),
                      ),
                    ],
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isApproved
                            ? AppColors.successGreen.withOpacity(0.3)
                            : AppColors.errorRed.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isApproved ? Icons.check_circle : Icons.cancel,
                          color: isApproved
                              ? AppColors.successGreen
                              : AppColors.errorRed,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isApproved
                                ? 'This request has been approved'
                                : 'This request has been rejected',
                            style: AppStyles.small.copyWith(
                              color: isApproved
                                  ? AppColors.successGreen
                                  : AppColors.errorRed,
                              fontWeight: FontWeight.bold,
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

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryOrange, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text('$label: ${value ?? "N/A"}', style: AppStyles.body),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    if (value == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            label,
            style: AppStyles.small.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 5),
          Text(value, style: AppStyles.small),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warningYellow;
      case 'approved':
      case 'completed':
        return AppColors.successGreen;
      case 'rejected':
        return AppColors.errorRed;
      case 'payment_pending':
        return Colors.blue;
      default:
        return AppColors.textLightGrey;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox_outlined, color: AppColors.iconGrey, size: 80),
          const SizedBox(height: 16),
          Text('No Requests Yet', style: AppStyles.headline3),
          Text('Check back later for applications.', style: AppStyles.subtitle),
        ],
      ),
    );
  }

  Widget _buildErrorState(String? message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, color: AppColors.errorRed, size: 60),
            const SizedBox(height: 16),
            Text('Something went wrong', style: AppStyles.headline3),
            Text(
              message ?? 'Unknown error',
              style: AppStyles.subtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
              ),
              child: Text('Retry', style: AppStyles.button),
            ),
          ],
        ),
      ),
    );
  }

  void _updateAdoptionStatus(String id, String status, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.primaryWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Approve Request', style: AppStyles.headline3),
        content: Text(
          'Do you want to approve this applicant?',
          style: AppStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: AppStyles.small),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.successGreen,
            ),
            onPressed: () {
              ref.read(adoptionViewModelProvider.notifier).approveAdoption(id);
              Navigator.pop(ctx);
            },
            child: Text(
              'Confirm',
              style: AppStyles.button.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _showRejectReasonDialog(String id, BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.primaryWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Reject Request', style: AppStyles.headline3),
        content: TextField(
          controller: controller,
          maxLines: 3,
          style: AppStyles.body,
          decoration: InputDecoration(
            hintText: 'Reason for rejection...',
            hintStyle: AppStyles.small,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: AppStyles.small),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
            ),
            onPressed: () {
              if (controller.text.trim().isEmpty) return;
              ref
                  .read(adoptionViewModelProvider.notifier)
                  .rejectAdoption(id, controller.text.trim());
              Navigator.pop(ctx);
            },
            child: Text(
              'Reject',
              style: AppStyles.button.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  List<BusinessAdoptionEntity> _filterAdoptions(
    List<BusinessAdoptionEntity> adoptions,
  ) {
    if (_selectedFilter == 'all') return adoptions;
    return adoptions
        .where((a) => a.status.toLowerCase() == _selectedFilter)
        .toList();
  }
}
