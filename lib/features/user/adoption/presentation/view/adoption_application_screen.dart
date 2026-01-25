import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/adoption/presentation/state/adoption_state.dart';
import 'package:pet_connect/features/user/adoption/presentation/viewmodel/adoption_viewmodel.dart';

class AdoptionApplicationScreen extends ConsumerStatefulWidget {
  final String petId;
  final String petName;

  const AdoptionApplicationScreen({
    super.key,
    required this.petId,
    required this.petName,
  });

  @override
  ConsumerState<AdoptionApplicationScreen> createState() =>
      _AdoptionApplicationScreenState();
}

class _AdoptionApplicationScreenState
    extends ConsumerState<AdoptionApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'fullName': '',
    'phoneNumber': '',
    'address': '',
    'homeType': 'House',
    'hasYard': false,
    'employmentStatus': '',
    'numberOfAdults': '',
    'numberOfChildren': '',
    'hasOtherPets': false,
    'otherPetsDetails': '',
    'hoursPetAlone': '',
    'previousPetExperience': '',
    'message': '',
  };

  final List<String> _homeTypes = ['House', 'Apartment', 'Other'];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userAdoptionViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryWhite,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              'Adopt ${widget.petName}',
              style: AppStyles.headline3.copyWith(
                fontSize: 20,
                color: AppColors.textBlack,
              ),
            ),
            Text(
              'Application Form',
              style: AppStyles.small.copyWith(
                fontSize: 12,
                color: AppColors.textLightGrey,
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryOrange.withOpacity(0.15),
                    AppColors.primaryOrange.withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryOrange.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.pets,
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
                          'Welcome!',
                          style: AppStyles.headline3.copyWith(
                            fontSize: 18,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Fill out this form to start the adoption process',
                          style: AppStyles.small.copyWith(
                            color: AppColors.textDarkGrey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Personal Information
            _buildSectionTitle('Personal Information', Icons.person),
            _buildTextField(
              label: 'Full Name',
              field: 'fullName',
              required: true,
              icon: Icons.badge_outlined,
              validator: (value) =>
                  value?.isEmpty == true ? 'Name is required' : null,
            ),
            _buildTextField(
              label: 'Phone Number',
              field: 'phoneNumber',
              required: true,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) =>
                  value?.isEmpty == true ? 'Phone number is required' : null,
            ),
            _buildTextField(
              label: 'Address',
              field: 'address',
              required: true,
              icon: Icons.location_on_outlined,
              maxLines: 2,
              validator: (value) =>
                  value?.isEmpty == true ? 'Address is required' : null,
            ),

            const SizedBox(height: 20),

            // Housing Information
            _buildSectionTitle('Housing Information', Icons.home),
            _buildDropdown(
              label: 'Home Type',
              field: 'homeType',
              required: true,
              icon: Icons.home_work_outlined,
              items: _homeTypes,
            ),
            _buildSwitch(
              label: 'Do you have a yard?',
              field: 'hasYard',
              icon: Icons.yard_outlined,
            ),

            const SizedBox(height: 20),

            // Family Information
            _buildSectionTitle('Family Information', Icons.family_restroom),
            _buildTextField(
              label: 'Employment Status',
              field: 'employmentStatus',
              icon: Icons.work_outline,
            ),
            _buildTextField(
              label: 'Number of Adults',
              field: 'numberOfAdults',
              icon: Icons.people_outline,
              keyboardType: TextInputType.number,
            ),
            _buildTextField(
              label: 'Number of Children',
              field: 'numberOfChildren',
              icon: Icons.child_care_outlined,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            // Pet Experience
            _buildSectionTitle('Pet Experience', Icons.pets),
            _buildSwitch(
              label: 'Do you have other pets?',
              field: 'hasOtherPets',
              icon: Icons.pets_outlined,
            ),
            if (_formData['hasOtherPets'] == true)
              _buildTextField(
                label: 'Other Pets Details',
                field: 'otherPetsDetails',
                icon: Icons.info_outline,
                maxLines: 2,
              ),
            _buildTextField(
              label: 'Hours pet will be alone daily',
              field: 'hoursPetAlone',
              icon: Icons.access_time,
              keyboardType: TextInputType.number,
            ),
            _buildTextField(
              label: 'Previous Pet Experience',
              field: 'previousPetExperience',
              icon: Icons.history,
              maxLines: 3,
            ),

            const SizedBox(height: 20),

            // Additional Information
            _buildSectionTitle('Additional Information', Icons.message),
            _buildTextField(
              label: 'Message to Shelter',
              field: 'message',
              icon: Icons.message_outlined,
              maxLines: 4,
              hint: 'Tell us why you want to adopt ${widget.petName}...',
            ),

            const SizedBox(height: 40),

            // Submit Button
            Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryOrange,
                    AppColors.primaryOrange.withOpacity(0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryOrange.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: state.isLoading ? null : _submitApplication,
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: state.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Submit Application',
                                style: AppStyles.button.copyWith(fontSize: 17),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryOrange.withOpacity(0.15),
                  AppColors.primaryOrange.withOpacity(0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primaryOrange, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: AppStyles.headline3.copyWith(
              fontSize: 18,
              color: AppColors.textBlack,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String field,
    required IconData icon,
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label + (required ? ' *' : ''),
            labelStyle: AppStyles.body.copyWith(
              color: AppColors.textLightGrey,
              fontSize: 14,
            ),
            hintText: hint,
            hintStyle: AppStyles.small.copyWith(
              color: AppColors.textLightGrey.withOpacity(0.6),
            ),
            prefixIcon: Icon(icon, color: AppColors.primaryOrange, size: 22),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: AppColors.textLightGrey.withOpacity(0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: AppColors.textLightGrey.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.primaryOrange, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.errorRed),
            ),
            filled: true,
            fillColor: AppColors.primaryWhite,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          style: AppStyles.body.copyWith(color: AppColors.textBlack),
          keyboardType: keyboardType,
          maxLines: maxLines,
          initialValue: _formData[field]?.toString(),
          onChanged: (value) => _formData[field] = value,
          validator: validator,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String field,
    required IconData icon,
    required List<String> items,
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label + (required ? ' *' : ''),
            labelStyle: AppStyles.body.copyWith(
              color: AppColors.textLightGrey,
              fontSize: 14,
            ),
            prefixIcon: Icon(icon, color: AppColors.primaryOrange, size: 22),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: AppColors.textLightGrey.withOpacity(0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: AppColors.textLightGrey.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.primaryOrange, width: 2),
            ),
            filled: true,
            fillColor: AppColors.primaryWhite,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          style: AppStyles.body.copyWith(color: AppColors.textBlack),
          initialValue: _formData[field] as String?,
          items: items.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(
                type,
                style: AppStyles.body.copyWith(color: AppColors.textBlack),
              ),
            );
          }).toList(),
          onChanged: (value) => setState(() => _formData[field] = value),
          validator: (value) =>
              value?.isEmpty == true ? '$label is required' : null,
        ),
      ),
    );
  }

  Widget _buildSwitch({
    required String label,
    required String field,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.textLightGrey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryOrange, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppStyles.body.copyWith(color: AppColors.textBlack),
              ),
            ),
            Switch(
              value: _formData[field] as bool,
              onChanged: (value) => setState(() => _formData[field] = value),
              activeThumbColor: AppColors.primaryOrange,
              activeTrackColor: AppColors.primaryOrange.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  void _submitApplication() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Prepare data for API
      final applicationData = {
        'fullName': _formData['fullName'],
        'phoneNumber': _formData['phoneNumber'],
        'address': _formData['address'],
        'homeType': _formData['homeType'],
        'hasYard': _formData['hasYard'],
        'employmentStatus': _formData['employmentStatus'],
        'numberOfAdults': _formData['numberOfAdults'].isNotEmpty
            ? int.tryParse(_formData['numberOfAdults'])
            : null,
        'numberOfChildren': _formData['numberOfChildren'].isNotEmpty
            ? int.tryParse(_formData['numberOfChildren'])
            : null,
        'hasOtherPets': _formData['hasOtherPets'],
        'otherPetsDetails': _formData['otherPetsDetails'],
        'hoursPetAlone': _formData['hoursPetAlone'].isNotEmpty
            ? int.tryParse(_formData['hoursPetAlone'])
            : null,
        'previousPetExperience': _formData['previousPetExperience'],
        'message': _formData['message'],
      };

      await ref
          .read(userAdoptionViewModelProvider.notifier)
          .applyForAdoption(
            petId: widget.petId,
            applicationData: applicationData,
          );

      final currentState = ref.read(userAdoptionViewModelProvider);
      if (currentState.status != UserAdoptionStatus.error) {
        // Show success message and navigate back
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.primaryWhite),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      currentState.message ?? 'Application submitted!',
                      style: AppStyles.body.copyWith(
                        color: AppColors.primaryWhite,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColors.successGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: AppColors.primaryWhite),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      currentState.message ?? 'Failed to submit application',
                      style: AppStyles.body.copyWith(
                        color: AppColors.primaryWhite,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColors.errorRed,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      }
    }
  }
}
