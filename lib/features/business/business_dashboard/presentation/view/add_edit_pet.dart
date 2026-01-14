import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/core/utils/snackbar_utils.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/entity/pet_entity.dart';
import 'package:pet_connect/features/business/business_dashboard/presentation/state/pet_state.dart';
import 'package:pet_connect/features/business/business_dashboard/presentation/view/%20pets_list.dart';
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

  List<String> _existingPhotos = [];
  final List<File> _newPhotos = [];

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
      _existingPhotos = widget.pet!.photos ?? [];
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
      if (next.message != null && next.message != previous?.message) {
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

        // Clear the message after showing
        ref.read(petViewModelProvider.notifier).clearMessage();
      }
    });

    final state = ref.watch(petViewModelProvider);
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Form(
            key: _formKey,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCustomHeader(context),
                  const SizedBox(height: 30),

                  _buildSectionTitle(
                    title: 'Pet Photos',
                    icon: Icons.photo_library_outlined,
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 1 + _existingPhotos.length + _newPhotos.length,
                      itemBuilder: (context, index) {
                        if (index == 0) return _buildAddPhotoButton();
                        if (index <= _existingPhotos.length) {
                          return _buildExistingPhotoPreview(index - 1);
                        } else {
                          return _buildNewPhotoPreview(
                            index - _existingPhotos.length - 1,
                          );
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 35),

                  _buildSectionTitle(
                    title: 'Basic Details',
                    icon: Icons.info_outline,
                  ),
                  _buildSectionWrapper(
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        label: 'Pet Name',
                        hintText: 'Max, Bella, Charlie...',
                        icon: Icons.tag,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter pet name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      _buildTextField(
                        controller: _breedController,
                        label: 'Breed',
                        hintText: 'Golden Retriever, Siamese...',
                        icon: Icons.category_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter breed';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _ageController,
                              label: 'Age (Months)',
                              hintText: '3',
                              icon: Icons.calendar_today_outlined,
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
                          const SizedBox(width: 15),
                          Expanded(child: _buildGenderDropdown()),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),

                  _buildSectionTitle(
                    title: 'Status & Health',
                    icon: Icons.check_circle_outline,
                  ),
                  _buildSectionWrapper(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    children: [
                      _buildToggleSwitch(
                        title: 'Vaccinated',
                        subtitle: 'Pet has up-to-date vaccinations',
                        value: _isVaccinated,
                        onChanged: (value) {
                          setState(() {
                            _isVaccinated = value;
                          });
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(
                          color: AppColors.backgroundGrey,
                          height: 1,
                          thickness: 1,
                        ),
                      ),
                      _buildToggleSwitch(
                        title: 'Available for Adoption',
                        value: _isAvailable,
                        onChanged: (value) {
                          setState(() {
                            _isAvailable = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),

                  _buildSectionTitle(
                    title: 'Personality & Medical',
                    icon: Icons.description_outlined,
                  ),
                  _buildSectionWrapper(
                    children: [
                      _buildTextField(
                        controller: _personalityController,
                        label: 'Personality & Temperament',
                        hintText: 'Friendly, playful, calm, loves kids, etc.',
                        icon: Icons.emoji_emotions_outlined,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),

                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        hintText: 'Tell us about your pet, their story, etc.',
                        icon: Icons.text_snippet_outlined,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 20),

                      _buildTextField(
                        controller: _medicalController,
                        label: 'Medical Information (Optional)',
                        hintText: 'Any medical conditions or special needs',
                        icon: Icons.medical_services_outlined,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

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
                              borderRadius: BorderRadius.circular(15),
                            ),
                            minimumSize: const Size(double.infinity, 58),
                            elevation: 8,
                            shadowColor: AppColors.primaryOrange.withOpacity(
                              0.5,
                            ),
                          ),
                          child: Text(
                            widget.pet == null
                                ? 'CREATE NEW PET PROFILE'
                                : 'UPDATE PET PROFILE',
                            style: AppStyles.button.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const PetListScreen()),
            );
          },
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textDarkGrey),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 15),
        Text(
          widget.pet == null ? 'Create New Profile' : 'Edit Pet Details',
          style: AppStyles.headline2.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textDarkGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle({required String title, required IconData icon}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryOrange, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppStyles.headline3.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textDarkGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionWrapper({
    required List<Widget> children,
    EdgeInsets padding = const EdgeInsets.all(20),
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.textLightGrey.withOpacity(0.15),
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
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
    final FocusNode focusNode = FocusNode();
    Color borderColor = AppColors.textLightGrey.withOpacity(0.5);

    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          borderColor = hasFocus
              ? AppColors.primaryOrange
              : AppColors.textLightGrey.withOpacity(0.5);
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppStyles.body.copyWith(
              fontSize: 15,
              color: AppColors.textDarkGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            validator: validator,
            focusNode: focusNode,
            style: AppStyles.body.copyWith(color: AppColors.textDarkGrey),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.backgroundGrey.withOpacity(0.1),
              hintText: hintText,
              hintStyle: AppStyles.body.copyWith(
                color: AppColors.textLightGrey,
              ),
              prefixIcon: Icon(icon, color: AppColors.primaryOrange, size: 22),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: borderColor, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: AppColors.textLightGrey.withOpacity(0.3),
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: AppColors.primaryOrange,
                  width: 2.0,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: maxLines > 1 ? 15 : 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: AppStyles.body.copyWith(
            fontSize: 15,
            color: AppColors.textDarkGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: AppColors.backgroundGrey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppColors.textLightGrey.withOpacity(0.3),
              width: 1.0,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedGender,
              hint: Text(
                'Select',
                style: AppStyles.body.copyWith(color: AppColors.textLightGrey),
              ),
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryOrange),
              style: AppStyles.body.copyWith(
                color: AppColors.textDarkGrey,
                fontSize: 16,
              ),
              items: ['Male', 'Female', 'Other'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
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
    );
  }

  Widget _buildToggleSwitch({
    required String title,
    String? subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppStyles.body.copyWith(
                  fontSize: 16,
                  color: AppColors.textDarkGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppStyles.small.copyWith(
                    fontSize: 12,
                    color: AppColors.textLightGrey,
                  ),
                ),
              ],
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primaryOrange,
          activeTrackColor: AppColors.primaryOrange.withOpacity(0.5),
          inactiveThumbColor: AppColors.textLightGrey,
          inactiveTrackColor: AppColors.textLightGrey.withOpacity(0.3),
        ),
      ],
    );
  }

  Widget _buildAddPhotoButton() {
    return GestureDetector(
      onTap: _pickImage,
      child: Card(
        elevation: 4,
        shadowColor: AppColors.primaryOrange.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 120,
          height: 140,
          margin: const EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryOrange.withOpacity(0.7),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_a_photo_outlined,
                color: AppColors.primaryOrange,
                size: 30,
              ),
              const SizedBox(height: 8),
              Text(
                'Add Photo',
                style: AppStyles.body.copyWith(
                  color: AppColors.primaryOrange,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExistingPhotoPreview(int index) {
    return Stack(
      children: [
        Container(
          width: 120,
          height: 140,
          margin: const EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: NetworkImage(_existingPhotos[index]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 10,
          child: GestureDetector(
            onTap: () => setState(() => _existingPhotos.removeAt(index)),
            child: _buildRemoveIcon(),
          ),
        ),
      ],
    );
  }

  Widget _buildNewPhotoPreview(int index) {
    return Stack(
      children: [
        Container(
          width: 120,
          height: 140,
          margin: const EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: FileImage(_newPhotos[index]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 10,
          child: GestureDetector(
            onTap: () => setState(() => _newPhotos.removeAt(index)),
            child: _buildRemoveIcon(),
          ),
        ),
      ],
    );
  }

  Widget _buildRemoveIcon() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.errorRed,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryWhite, width: 2),
      ),
      child: const Icon(Icons.close, color: AppColors.primaryWhite, size: 14),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (_existingPhotos.length + _newPhotos.length >= 5) {
        showSnackBar(
          context: context,
          message: 'Maximum 5 photos allowed.',
          isSuccess: false,
        );
        return;
      }
      setState(() => _newPhotos.add(File(image.path)));
    }
  }

  void _savePet() async {
    if (_formKey.currentState!.validate() && _selectedGender != null) {
      // Convert File objects to file paths for new photos
      final newPhotoPaths = _newPhotos.map((file) => file.path).toList();

      // Create PetEntity with existing photos only (URLs from Cloudinary)
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
        photos: _existingPhotos, // Only existing Cloudinary URLs
        available: _isAvailable,
      );
      if (widget.pet == null) {
        await ref
            .read(petViewModelProvider.notifier)
            .addPet(pet, newPhotoPaths.isEmpty ? null : newPhotoPaths);
      } else {
        await ref
            .read(petViewModelProvider.notifier)
            .updatePet(
              pet,
              newPhotoPaths.isEmpty ? null : newPhotoPaths,
              widget.pet!.id!,
            );
      }
    } else {
      showSnackBar(
        context: context,
        message: 'Please fill all required fields and select gender',
        isSuccess: false,
      );
    }
  }
}
