import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/businesses/domain/entity/business_entity.dart';
import 'package:pet_connect/features/user/businesses/presentation/state/business_state.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

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

    _scrollController.addListener(() {
      if (_scrollController.offset > 100 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 100 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });

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
    _scrollController.dispose();
    super.dispose();
  }

  void _showBusinessInfo(BuildContext context, BusinessEntity business) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
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
                  // Business Profile Image in Info Sheet
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryOrange.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: _buildBusinessProfileImage(business),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          business.businessName,
                          style: AppStyles.headline3.copyWith(fontSize: 20),
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
            Divider(height: 1, color: AppColors.backgroundGrey),
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

  Widget _buildBusinessProfileImage(BusinessEntity business) {
    final imageUrl = business.profileImageUrl;

    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        color: AppColors.primaryWhite,
        child: Center(
          child: Icon(Icons.business, size: 30, color: AppColors.primaryOrange),
        ),
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryOrange,
            strokeWidth: 2,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: AppColors.primaryWhite,
          child: Center(
            child: Icon(
              Icons.business,
              size: 30,
              color: AppColors.primaryOrange,
            ),
          ),
        );
      },
    );
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
          : CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Enhanced App Bar
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: true,
                  stretch: true,
                  backgroundColor: AppColors.primaryWhite,
                  elevation: _isScrolled ? 2 : 0,
                  leading: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _isScrolled
                          ? AppColors.primaryWhite
                          : Colors.black.withOpacity(0.4),
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
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: _isScrolled
                            ? AppColors.textBlack
                            : AppColors.primaryWhite,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  actions: [
                    if (business != null)
                      Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isScrolled
                              ? AppColors.primaryWhite
                              : Colors.black.withOpacity(0.4),
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
                          icon: Icon(
                            Icons.info_outline,
                            color: _isScrolled
                                ? AppColors.textBlack
                                : AppColors.primaryWhite,
                          ),
                          onPressed: () => _showBusinessInfo(context, business),
                        ),
                      ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    titlePadding: EdgeInsets.zero,
                    title: _isScrolled && business != null
                        ? Container(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              business.businessName,
                              style: AppStyles.headline3.copyWith(
                                fontSize: 16,
                                color: AppColors.textBlack,
                              ),
                            ),
                          )
                        : null,
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Business Cover Image
                        if (business != null &&
                            business.profileImageUrl != null &&
                            business.profileImageUrl!.isNotEmpty)
                          Image.network(
                            business.profileImageUrl!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryOrange,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return _buildFallbackBackground();
                            },
                          )
                        else
                          _buildFallbackBackground(),

                        // Gradient Overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.3),
                                Colors.black.withOpacity(0.7),
                              ],
                              stops: const [0.3, 1.0],
                            ),
                          ),
                        ),

                        // Business Info at Bottom
                        if (business != null)
                          Positioned(
                            left: 24,
                            right: 24,
                            bottom: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Business Name
                                Text(
                                  business.businessName,
                                  style: AppStyles.headline2.copyWith(
                                    color: AppColors.primaryWhite,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 12,
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Username Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryWhite.withOpacity(
                                      0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.primaryWhite.withOpacity(
                                        0.3,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.alternate_email,
                                        size: 14,
                                        color: AppColors.primaryWhite,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        business.username,
                                        style: AppStyles.body.copyWith(
                                          color: AppColors.primaryWhite,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
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
                  ),
                ),

                // Available Pets Header Section
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available Pets',
                            style: AppStyles.headline2.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Discover adorable companions waiting for a loving home',
                            style: AppStyles.body.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),

                // Pets Grid
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: business != null
                        ? BusinessPetsSection(businessEntity: business)
                        : _buildLoadingOrErrorState(businessState),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildFallbackBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryOrange,
            AppColors.primaryOrange.withOpacity(0.6),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.storefront_rounded,
          size: 120,
          color: AppColors.primaryWhite.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildLoadingOrErrorState(BusinessState state) {
    if (state.isError) {
      return Container(
        height: 300,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(32),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.errorRed.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 50,
                  color: AppColors.errorRed,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Oops! Something went wrong',
                style: AppStyles.headline3.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                state.message ?? 'Failed to load business details',
                style: AppStyles.body.copyWith(color: AppColors.textGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  ref
                      .read(businessViewModelProvider.notifier)
                      .getBusinessById(widget.businessId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: AppColors.primaryWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  elevation: 2,
                ),
                icon: const Icon(Icons.refresh, size: 20),
                label: Text(
                  'Try Again',
                  style: AppStyles.button.copyWith(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Default loading state
    return SizedBox(
      height: 300,
      child: Center(
        child: CircularProgressIndicator(color: AppColors.primaryOrange),
      ),
    );
  }
}
