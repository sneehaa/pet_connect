import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/businesses/domain/entity/business_entity.dart';
import 'package:pet_connect/features/user/businesses/presentation/view/widget/business_contact_section.dart';
import 'package:pet_connect/features/user/businesses/presentation/view/widget/business_info_section.dart';
import 'package:pet_connect/features/user/businesses/presentation/view/widget/business_pets_section.dart';
import 'package:pet_connect/features/user/businesses/presentation/view/widget/business_policy_section.dart';
import 'package:pet_connect/features/user/businesses/presentation/viewmodel/business_viewmodel.dart';
import 'package:pet_connect/features/user/pets/presentation/viewmodel/pet_viewmodel.dart';

class BusinessDetailScreen extends ConsumerStatefulWidget {
  final String businessId;
  const BusinessDetailScreen({super.key, required this.businessId});

  @override
  ConsumerState<BusinessDetailScreen> createState() =>
      _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends ConsumerState<BusinessDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(businessViewModelProvider.notifier)
          .getBusinessById(widget.businessId);
      ref
          .read(petViewModelProvider.notifier)
          .loadPetsByBusiness(widget.businessId);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showBusinessInfo(BuildContext context, BusinessEntity business) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            // Drag Handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textLightGrey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.store_rounded,
                      color: AppColors.primaryOrange,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          business.businessName,
                          style: AppStyles.headline3.copyWith(fontSize: 22),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Business Information',
                          style: AppStyles.small.copyWith(
                            color: AppColors.textLightGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BusinessInfoSection(business: business),
                    const SizedBox(height: 24),
                    BusinessContactSection(business: business),
                    if (business.adoptionPolicy != null) ...[
                      const SizedBox(height: 24),
                      BusinessPolicySection(business: business),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final businessState = ref.watch(businessViewModelProvider);
    final business = businessState.selectedBusiness;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: businessState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // Modern App Bar with Hero Image
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: true,
                  stretch: true,
                  backgroundColor: AppColors.primaryOrange,
                  leading: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  actions: [
                    if (business != null)
                      Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.info_outline,
                            color: Colors.black87,
                          ),
                          onPressed: () => _showBusinessInfo(context, business),
                        ),
                      ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    title: business != null
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              business.businessName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : null,
                    centerTitle: true,
                    titlePadding: const EdgeInsets.only(bottom: 16),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Gradient Background
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primaryOrange,
                                AppColors.primaryOrange.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        // Decorative Pattern
                        Positioned(
                          right: -50,
                          top: -50,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                        Positioned(
                          left: -30,
                          bottom: -30,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                        // Icon
                        Center(
                          child: Icon(
                            Icons.storefront_rounded,
                            size: 100,
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Section Header
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryOrange.withOpacity(0.1),
                            AppColors.primaryOrange.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primaryOrange.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryOrange,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.pets,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Available Pets',
                                  style: AppStyles.headline3.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Find your perfect companion',
                                  style: AppStyles.small.copyWith(
                                    color: AppColors.textLightGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Pets Grid
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: BusinessPetsSection(businessId: widget.businessId),
                  ),
                ),
              ],
            ),
    );
  }
}
