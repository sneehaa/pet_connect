import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/core/utils/snackbar_utils.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/entity/pet_entity.dart';
import 'package:pet_connect/features/business/business_dashboard/presentation/state/pet_state.dart';
import 'package:pet_connect/features/business/business_dashboard/presentation/viewmodel/pet_view_model.dart';

class AddEditPetScreen extends ConsumerStatefulWidget {
  final PetEntity? pet;
  const AddEditPetScreen({super.key, this.pet});

  @override
  ConsumerState<AddEditPetScreen> createState() => _AddEditPetScreenState();
}

class _AddEditPetScreenState extends ConsumerState<AddEditPetScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _personalityController = TextEditingController();
  final TextEditingController _medicalController = TextEditingController();

  String? _selectedGender;
  bool _isVaccinated = false;
  bool _isAvailable = true;
  final List<File> _selectedPhotos = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.pet != null) {
      _nameController.text = widget.pet!.name;
      _breedController.text = widget.pet!.breed;
      _ageController.text = widget.pet!.age.toString();
      _selectedGender = widget.pet!.gender;
      _isVaccinated = widget.pet!.vaccinated;
      _isAvailable = widget.pet!.available;
      _descriptionController.text = widget.pet!.description ?? '';
      _personalityController.text = widget.pet!.personality ?? '';
      _medicalController.text = widget.pet!.medicalInfo ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _descriptionController.dispose();
    _personalityController.dispose();
    _medicalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<PetState>(petViewModelProvider, (previous, next) {
      if (next.message != null) {
        showSnackBar(
          context: context,
          message: next.message!,
          isSuccess:
              !next.message!.contains('Failed') &&
              !next.message!.contains('error'),
        );

        if (next.message!.contains('successfully')) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context);
          });
        }
      }
    });

    final state = ref.watch(petViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryWhite,
        elevation: 0,
        title: Text(
          widget.pet == null ? 'Add New Pet' : 'Edit Pet Details',
          style: AppStyles.headline2.copyWith(color: AppColors.textDarkGrey),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: AppColors.textDarkGrey),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photos Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Photos', style: AppStyles.headline3),
                    const SizedBox(height: 10),
                    Text(
                      'Add clear photos of your pet',
                      style: AppStyles.subtitle,
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedPhotos.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return _buildAddPhotoButton();
                          } else {
                            return _buildPhotoPreview(index - 1);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),

                // Basic Info
                Text('Basic Information', style: AppStyles.headline3),
                const SizedBox(height: 20),

                // Name
                _buildTextField(
                  controller: _nameController,
                  label: 'Pet Name',
                  hintText: 'Enter pet name',
                  icon: Icons.pets,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter pet name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Breed
                _buildTextField(
                  controller: _breedController,
                  label: 'Breed',
                  hintText: 'Enter breed',
                  icon: Icons.category,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter breed';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    // Age
                    Expanded(
                      child: _buildTextField(
                        controller: _ageController,
                        label: 'Age (years)',
                        hintText: 'Age',
                        icon: Icons.cake,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter age';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Gender
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gender',
                            style: GoogleFonts.alice(
                              fontSize: 16,
                              color: AppColors.textDarkGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundGrey.withOpacity(0.45),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedGender,
                                hint: Text(
                                  'Select Gender',
                                  style: GoogleFonts.alice(
                                    color: AppColors.textLightGrey,
                                  ),
                                ),
                                isExpanded: true,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColors.textLightGrey,
                                ),
                                items: ['Male', 'Female', 'Other'].map((
                                  String value,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: GoogleFonts.alice(
                                        color: AppColors.textDarkGrey,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Toggle Switches
                _buildToggleSwitch(
                  title: 'Vaccinated',
                  subtitle: 'Pet has been vaccinated',
                  value: _isVaccinated,
                  onChanged: (value) {
                    setState(() {
                      _isVaccinated = value;
                    });
                  },
                ),
                const SizedBox(height: 15),
                _buildToggleSwitch(
                  title: 'Available for Adoption',
                  subtitle: 'Pet is available for adoption',
                  value: _isAvailable,
                  onChanged: (value) {
                    setState(() {
                      _isAvailable = value;
                    });
                  },
                ),
                const SizedBox(height: 30),

                // Description
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  hintText: 'Tell us about your pet...',
                  icon: Icons.description,
                  maxLines: 4,
                ),
                const SizedBox(height: 20),

                // Personality
                _buildTextField(
                  controller: _personalityController,
                  label: 'Personality & Temperament',
                  hintText: 'Friendly, playful, calm, etc.',
                  icon: Icons.emoji_emotions,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),

                // Medical Information
                _buildTextField(
                  controller: _medicalController,
                  label: 'Medical Information (Optional)',
                  hintText: 'Any medical conditions or special needs',
                  icon: Icons.medical_services,
                  maxLines: 3,
                ),
                const SizedBox(height: 40),

                // Submit Button
                state.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryOrange,
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              _selectedGender != null) {
                            _savePet();
                          } else if (_selectedGender == null) {
                            showSnackBar(
                              context: context,
                              message: 'Please select gender',
                              isSuccess: false,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size(double.infinity, 56),
                        ),
                        child: Text(
                          widget.pet == null ? 'Add Pet' : 'Update Pet',
                          style: AppStyles.button.copyWith(fontSize: 20),
                        ),
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddPhotoButton() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 120,
        height: 150,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: AppColors.backgroundGrey.withOpacity(0.45),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryOrange.withOpacity(0.3),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, color: AppColors.primaryOrange, size: 40),
            const SizedBox(height: 10),
            Text(
              'Add Photo',
              style: GoogleFonts.alice(
                color: AppColors.primaryOrange,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPreview(int index) {
    return Stack(
      children: [
        Container(
          width: 120,
          height: 150,
          margin: const EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: FileImage(_selectedPhotos[index]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedPhotos.removeAt(index);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.alice(
            fontSize: 16,
            color: AppColors.textDarkGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.backgroundGrey.withOpacity(0.45),
            hintText: hintText,
            hintStyle: GoogleFonts.alice(color: AppColors.textLightGrey),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(icon, color: AppColors.textLightGrey, size: 22),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: maxLines > 1 ? 20 : 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.alice(
                fontSize: 16,
                color: AppColors.textDarkGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.alice(
                fontSize: 14,
                color: AppColors.textLightGrey,
              ),
            ),
          ],
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primaryOrange,
          activeTrackColor: AppColors.primaryOrange.withOpacity(0.3),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedPhotos.add(File(image.path));
      });
    }
  }

  void _savePet() {
    final pet = PetEntity(
      id: widget.pet?.id,
      name: _nameController.text.trim(),
      breed: _breedController.text.trim(),
      age: int.parse(_ageController.text.trim()),
      gender: _selectedGender!,
      vaccinated: _isVaccinated,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      personality: _personalityController.text.trim().isEmpty
          ? null
          : _personalityController.text.trim(),
      medicalInfo: _medicalController.text.trim().isEmpty
          ? null
          : _medicalController.text.trim(),
      photos: widget.pet?.photos, // Keep existing photos
      available: _isAvailable,
    );

    // Convert selected photos to paths
    final photoPaths = _selectedPhotos.map((file) => file.path).toList();

    if (widget.pet == null) {
      ref.read(petViewModelProvider.notifier).addPet(pet, photoPaths);
    } else {
      ref.read(petViewModelProvider.notifier).updatePet(pet, photoPaths);
    }
  }
}
