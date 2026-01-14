import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/core/utils/snackbar_utils.dart';
import 'package:pet_connect/features/business/business_auth/domain/entity/business_entity.dart';
import 'package:pet_connect/features/business/business_auth/presentation/auth_viewmodel/auth_viewmodel.dart';
import 'package:pet_connect/features/business/business_auth/presentation/state/auth_state.dart';
import 'package:pet_connect/features/business/business_auth/presentation/view/upload_document.dart';
import 'package:pet_connect/features/user/auth/presentation/view/login_view.dart';

class BusinessSignupScreen extends ConsumerStatefulWidget {
  const BusinessSignupScreen({super.key});

  @override
  ConsumerState<BusinessSignupScreen> createState() =>
      _BusinessSignupScreenState();
}

class _BusinessSignupScreenState extends ConsumerState<BusinessSignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<BusinessState>(businessViewModelProvider, (previous, next) {
      if (previous?.isLoading == true &&
          next.isLoading == false &&
          next.message != null) {
        showSnackBar(
          context: context,
          message: next.message!,
          isSuccess: !next.isError,
        );
      }
      if (previous?.isLoading == true &&
          next.isLoading == false &&
          !next.isError &&
          next.flow == BusinessFlow.registered) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const UploadBusinessDocument()),
            );
          }
        });
      }
    });

    final state = ref.watch(businessViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 118,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/petConnect.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Text(
                        'Create your Business Account',
                        style: AppStyles.headline3,
                      ),
                      Text(
                        'Please enter your details',
                        style: AppStyles.subtitle,
                      ),

                      // Improved Profile Image Upload Section
                      const SizedBox(height: 24),
                      Stack(
                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.backgroundGrey.withOpacity(0.5),
                              border: Border.all(
                                color: AppColors.primaryOrange,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryOrange.withOpacity(
                                    0.2,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: _profileImage == null
                                ? Icon(
                                    Icons.business,
                                    size: 60,
                                    color: AppColors.textLightGrey.withOpacity(
                                      0.6,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(65),
                                    child: Image.file(
                                      _profileImage!,
                                      fit: BoxFit.cover,
                                      width: 130,
                                      height: 130,
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryOrange,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primaryWhite,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: AppColors.primaryWhite,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _businessNameController,
                              labelText: 'Business Name',
                              iconPath: 'assets/icons/user.png',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter business name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _usernameController,
                              labelText: 'Username',
                              iconPath: 'assets/icons/user.png',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a username';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _emailController,
                              labelText: 'Email',
                              iconPath: 'assets/icons/email.png',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _passwordController,
                              labelText: 'Password',
                              iconPath: 'assets/icons/password.png',
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _phoneNumberController,
                              labelText: 'Phone Number',
                              iconPath: 'assets/icons/phone.png',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _addressController,
                              labelText: 'Address',
                              iconPath: 'assets/icons/address.png',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 40),
                            state.isLoading
                                ? const CircularProgressIndicator(
                                    color: AppColors.primaryOrange,
                                  )
                                : ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        final businessEntity = BusinessEntity(
                                          businessId: null,
                                          businessName: _businessNameController
                                              .text
                                              .trim(),
                                          username: _usernameController.text
                                              .trim(),
                                          email: _emailController.text.trim(),
                                          phoneNumber: _phoneNumberController
                                              .text
                                              .trim(),
                                          password: _passwordController.text
                                              .trim(),
                                          address: _addressController.text
                                              .trim(),
                                          role: 'BUSINESS',
                                          profileImagePath: _profileImage?.path,
                                        );

                                        await ref
                                            .read(
                                              businessViewModelProvider
                                                  .notifier,
                                            )
                                            .registerBusiness(businessEntity);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryOrange,
                                      minimumSize: const Size(230, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 3,
                                    ),
                                    child: Text(
                                      "Signup",
                                      style: AppStyles.button.copyWith(
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: AppStyles.body.copyWith(
                                    color: AppColors.textDarkGrey,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  ),
                                  child: Text(
                                    "Login!",
                                    style: AppStyles.linkText.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String iconPath,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: AppStyles.body,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.backgroundGrey.withOpacity(0.45),
        labelText: labelText,
        labelStyle: AppStyles.subtitle,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(iconPath, width: 24, height: 24),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryOrange, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.errorRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.errorRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
      validator: validator,
    );
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
