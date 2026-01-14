import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/features/user/businesses/domain/entity/business_entity.dart';
import 'package:pet_connect/features/user/businesses/presentation/view/widget/business_app_bar.dart';
import 'package:pet_connect/features/user/businesses/presentation/view/widget/business_contact_section.dart';
import 'package:pet_connect/features/user/businesses/presentation/view/widget/business_header.dart';
import 'package:pet_connect/features/user/businesses/presentation/view/widget/business_info_section.dart';
import 'package:pet_connect/features/user/businesses/presentation/view/widget/business_pets_section.dart';
import 'package:pet_connect/features/user/businesses/presentation/view/widget/business_policy_section.dart';
import 'package:pet_connect/features/user/businesses/presentation/view/widget/contact_options_sheet.dart';
import 'package:pet_connect/features/user/businesses/presentation/view/widget/error_state_widget.dart';
import 'package:pet_connect/features/user/businesses/presentation/viewmodel/business_viewmodel.dart'; 
import 'package:pet_connect/features/user/pets/presentation/viewmodel/pet_viewmodel.dart';

class BusinessDetailScreen extends ConsumerStatefulWidget {
  final String businessId;

  const BusinessDetailScreen({super.key, required this.businessId});

  @override
  ConsumerState<BusinessDetailScreen> createState() =>
      _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends ConsumerState<BusinessDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load business details
      ref
          .read(businessViewModelProvider.notifier)
          .getBusinessById(widget.businessId);

      // Load pets for this business
      ref
          .read(petViewModelProvider.notifier)
          .loadPetsByBusiness(widget.businessId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final businessState = ref.watch(businessViewModelProvider);
    final business = businessState.selectedBusiness;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: businessState.isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.primaryOrange),
            )
          : business == null
          ? ErrorStateWidget(
              message: 'Failed to load business details',
              onRetry: () => Navigator.pop(context),
            )
          : CustomScrollView(
              slivers: [
                BusinessAppBar(
                  onBackPressed: () {
                    ref
                        .read(businessViewModelProvider.notifier)
                        .clearSelectedBusiness();
                    Navigator.pop(context);
                  },
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      BusinessHeader(business: business),
                      BusinessInfoSection(business: business),
                      BusinessContactSection(business: business),
                      if (business.adoptionPolicy != null)
                        BusinessPolicySection(business: business),
                      BusinessPetsSection(businessId: widget.businessId),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: business != null
          ? FloatingActionButton.extended(
              onPressed: () {
                _showContactOptions(context, business);
              },
              backgroundColor: AppColors.primaryOrange,
              icon: const Icon(Icons.phone, color: Colors.white),
              label: const Text(
                'Contact',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  void _showContactOptions(BuildContext context, BusinessEntity business) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ContactOptionsSheet(business: business),
    );
  }
}
