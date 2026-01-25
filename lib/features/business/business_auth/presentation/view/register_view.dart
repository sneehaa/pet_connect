import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/core/utils/snackbar_utils.dart';
import 'package:pet_connect/features/business/business_auth/domain/entity/business_entity.dart';
import 'package:pet_connect/features/business/business_auth/presentation/auth_viewmodel/auth_viewmodel.dart';
import 'package:pet_connect/features/business/business_auth/presentation/state/auth_state.dart';
import 'package:pet_connect/features/business/business_auth/presentation/view/otp_verification.dart';
import 'package:pet_connect/features/user/auth/presentation/view/login_view.dart';

// Local provider for password visibility
final businessSignupPasswordVisibleProvider = StateProvider.autoDispose<bool>(
  (ref) => true,
);

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
      setState(() => _profileImage = File(image.path));
    }
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

  @override
  Widget build(BuildContext context) {
    final obscurePassword = ref.watch(businessSignupPasswordVisibleProvider);
    final state = ref.watch(businessViewModelProvider);

    ref.listen<BusinessState>(businessViewModelProvider, (previous, next) {
      if (next.message != null && previous?.message != next.message) {
        showSnackBar(
          context: context,
          message: next.message!,
          isSuccess: !next.isError,
        );
      }
      if (next.flow == BusinessFlow.needsOtp) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const BusinessOtpVerificationScreen(),
              ),
            );
          }
        });
      }
    });

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
                      _buildLogo(),
                      Text(
                        'Create Business Account',
                        style: AppStyles.headline3,
                      ),
                      Text(
                        'Please enter your details',
                        style: AppStyles.subtitle,
                      ),
                      const SizedBox(height: 24),
                      _buildImagePicker(),
                      const SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildTextField(
                              _businessNameController,
                              'Business Name',
                              'assets/icons/user.png',
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              _usernameController,
                              'Username',
                              'assets/icons/user.png',
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              _emailController,
                              'Email',
                              'assets/icons/email.png',
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 12),
                            _buildPasswordField(obscurePassword),
                            const SizedBox(height: 12),
                            _buildTextField(
                              _phoneNumberController,
                              'Phone Number',
                              'assets/icons/phone.png',
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              _addressController,
                              'Address',
                              'assets/icons/address.png',
                            ),
                            const SizedBox(height: 40),
                            _buildSignupButton(state),
                            const SizedBox(height: 16),
                            _buildLoginLink(),
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

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 118,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/petConnect.png'),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Stack(
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.backgroundGrey.withOpacity(0.5),
            border: Border.all(color: AppColors.primaryOrange, width: 3),
          ),
          child: _profileImage == null
              ? Icon(
                  Icons.business,
                  size: 60,
                  color: AppColors.textLightGrey.withOpacity(0.6),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(65),
                  child: Image.file(_profileImage!, fit: BoxFit.cover),
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
              decoration: const BoxDecoration(
                color: AppColors.primaryOrange,
                shape: BoxShape.circle,
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
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String icon, {
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppStyles.body,
      decoration: _inputDecoration(label, icon),
      validator: (v) => v!.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildPasswordField(bool obscure) {
    return TextFormField(
      controller: _passwordController,
      obscureText: obscure,
      style: AppStyles.body,
      decoration: _inputDecoration('Password', 'assets/icons/password.png')
          .copyWith(
            suffixIcon: IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textLightGrey,
              ),
              onPressed: () =>
                  ref
                          .read(businessSignupPasswordVisibleProvider.notifier)
                          .state =
                      !obscure,
            ),
          ),
      validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
    );
  }

  InputDecoration _inputDecoration(String label, String icon) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.backgroundGrey.withOpacity(0.45),
      labelText: label,
      labelStyle: AppStyles.subtitle,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.asset(icon, width: 24, height: 24),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryOrange, width: 2),
      ),
    );
  }

  Widget _buildSignupButton(BusinessState state) {
    return state.isLoading
        ? const CircularProgressIndicator(color: AppColors.primaryOrange)
        : ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final business = BusinessEntity(
                  businessId: null,
                  businessName: _businessNameController.text.trim(),
                  username: _usernameController.text.trim(),
                  email: _emailController.text.trim(),
                  phoneNumber: _phoneNumberController.text.trim(),
                  password: _passwordController.text.trim(),
                  address: _addressController.text.trim(),
                  role: 'BUSINESS',
                  profileImagePath: _profileImage?.path,
                );
                await ref
                    .read(businessViewModelProvider.notifier)
                    .registerBusiness(business);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
              minimumSize: const Size(230, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Signup",
              style: AppStyles.button.copyWith(fontSize: 22),
            ),
          );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: AppStyles.body.copyWith(color: AppColors.textDarkGrey),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          ),
          child: Text(
            "Login!",
            style: AppStyles.linkText.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
