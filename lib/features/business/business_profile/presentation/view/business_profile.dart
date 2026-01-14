import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/business/business_profile/domain/entity/business_profile_entity.dart';
import 'package:pet_connect/features/business/business_profile/presentation/state/business_profile_state.dart';
import 'package:pet_connect/features/business/business_profile/presentation/viewmodel/business_profile_viewmodel.dart';

import 'widgets/document_grid.dart';
import 'widgets/info_card.dart';
import 'widgets/profile_edit_form.dart';
// Import our custom widgets
import 'widgets/profile_header_card.dart';
import 'widgets/section_header.dart';

class BusinessProfileScreen extends ConsumerStatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  ConsumerState<BusinessProfileScreen> createState() =>
      _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends ConsumerState<BusinessProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _adoptionPolicyController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  bool _isEditing = false;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  void _loadProfile() {
    ref.read(businessProfileViewModelProvider.notifier).getMyProfile();
  }

  void _populateForm(BusinessProfileEntity profile) {
    _businessNameController.text = profile.businessName;
    _phoneController.text = profile.phoneNumber;
    _addressController.text = profile.address ?? '';
    _adoptionPolicyController.text = profile.adoptionPolicy ?? '';

    if (profile.location != null) {
      _latitudeController.text = profile.location!.latitude.toString();
      _longitudeController.text = profile.location!.longitude.toString();
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _loadProfile();
      }
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final profile = BusinessProfileEntity(
        businessName: _businessNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        adoptionPolicy: _adoptionPolicyController.text.trim(),
        businessStatus: 'Approved',
        location:
            (_latitudeController.text.isNotEmpty &&
                _longitudeController.text.isNotEmpty)
            ? LocationEntity(
                coordinates: [
                  double.parse(_longitudeController.text),
                  double.parse(_latitudeController.text),
                ],
              )
            : null,
      );

      if (_isFirstLoad) {
        ref
            .read(businessProfileViewModelProvider.notifier)
            .createProfile(profile);
      } else {
        ref
            .read(businessProfileViewModelProvider.notifier)
            .updateProfile(profile);
      }

      setState(() {
        _isEditing = false;
      });
    }
  }

  void _handleDocumentUpload() {
    // Implement document upload functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Upload Documents', style: AppStyles.headline3),
        content: Text(
          'Document upload functionality will be implemented here.',
          style: AppStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: AppStyles.linkText),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView(BusinessProfileEntity profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SectionHeader(
          title: 'Contact Information',
          subtitle: 'Your business contact details',
        ),
        InfoCard(
          icon: Icons.phone,
          title: 'Phone Number',
          value: profile.phoneNumber,
          isEditable: true,
          onEdit: () => setState(() => _isEditing = true),
        ),
        InfoCard(
          icon: Icons.location_on,
          title: 'Business Address',
          value: profile.address ?? 'Not set',
          isEditable: true,
          onEdit: () => setState(() => _isEditing = true),
        ),
        if (profile.location != null)
          InfoCard(
            icon: Icons.explore,
            title: 'Location Coordinates',
            value:
                '${profile.location!.latitude.toStringAsFixed(6)}, '
                '${profile.location!.longitude.toStringAsFixed(6)}',
            isEditable: true,
            onEdit: () => setState(() => _isEditing = true),
          ),

        const SizedBox(height: 32),

        // Adoption Policy Section
        if (profile.adoptionPolicy?.isNotEmpty ?? false)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: 'Adoption Policy',
                subtitle: 'Your adoption guidelines',
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryWhite,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  profile.adoptionPolicy!,
                  style: AppStyles.body.copyWith(fontSize: 15, height: 1.6),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),

        // Documents Section
        SectionHeader(
          title: 'Business Documents',
          subtitle: 'Verification and legal documents',
        ),
        DocumentGrid(
          documents: profile.documents ?? [],
          onAddDocument: _handleDocumentUpload, onViewDocument: (String p1) {  },
        ),

        const SizedBox(height: 40),

        // Quick Actions
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryOrange.withOpacity(0.05),
                AppColors.primaryWhite,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryOrange.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick Actions',
                style: AppStyles.headline3.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.upload_file,
                      label: 'Upload Docs',
                      onTap: _handleDocumentUpload,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.edit_document,
                      label: 'Edit Profile',
                      onTap: _toggleEditMode,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryOrange, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppStyles.body.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(businessProfileViewModelProvider);

    // Listen for state changes
    ref.listen(businessProfileViewModelProvider, (previous, current) {
      if (current.profile != null && _isFirstLoad) {
        _populateForm(current.profile!);
        setState(() {
          _isFirstLoad = false;
        });
      }

      if (current.flow == BusinessProfileFlow.created ||
          current.flow == BusinessProfileFlow.updated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  current.message ?? 'Profile saved successfully',
                  style: AppStyles.body.copyWith(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }

      if (current.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    current.error!,
                    style: AppStyles.body.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    });

    return Container(
      color: AppColors.background,
      child: state.isLoading && state.profile == null
          ? _buildLoadingState()
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  ProfileHeaderCard(
                    businessName:
                        state.profile?.businessName ?? 'Your Business',
                    email: state.profile?.email,
                    businessStatus: state.profile?.businessStatus ?? 'Pending',
                    isEditing: _isEditing,
                    onEditPressed: _toggleEditMode,
                  ),

                  const SizedBox(height: 32),

                  // Main Content
                  if (!_isEditing && state.profile != null)
                    _buildProfileView(state.profile!)
                  else if (_isEditing)
                    ProfileEditForm(
                      formKey: _formKey,
                      businessNameController: _businessNameController,
                      phoneController: _phoneController,
                      addressController: _addressController,
                      adoptionPolicyController: _adoptionPolicyController,
                      latitudeController: _latitudeController,
                      longitudeController: _longitudeController,
                      onSave: _saveProfile,
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryOrange.withOpacity(0.2),
                  AppColors.primaryOrange.withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryOrange,
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Loading Profile...',
            style: AppStyles.headline3.copyWith(color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            'Fetching your business information',
            style: AppStyles.small.copyWith(color: AppColors.textLightGrey),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _adoptionPolicyController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }
}
