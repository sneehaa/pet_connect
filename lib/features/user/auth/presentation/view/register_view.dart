import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/core/utils/snackbar_utils.dart';
import 'package:pet_connect/features/user/auth/domain/entity/auth_entity.dart';
import 'package:pet_connect/features/user/auth/presentation/auth_viewmodel/auth_viewmodel.dart';
import 'package:pet_connect/features/user/auth/presentation/state/auth_state.dart';
import 'package:pet_connect/features/user/auth/presentation/view/login_view.dart';
import 'package:pet_connect/features/user/auth/presentation/view/otp_verification.dart';

final passwordVisibilityProvider = StateProvider.autoDispose<bool>(
  (ref) => true,
);

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final obscurePassword = ref.watch(passwordVisibilityProvider);
    final state = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.message != null && previous?.message != next.message) {
        showSnackBar(
          context: context,
          message: next.message!,
          isSuccess: !next.isError,
        );
      }
      if (next.flow == AuthFlow.otpSent) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const UserOtpVerificationScreen()),
        );
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
                      const SizedBox(height: 20),
                      Text('Create your Account', style: AppStyles.headline2),
                      const SizedBox(height: 10),
                      Text(
                        'Please enter your details',
                        style: AppStyles.subtitle,
                      ),
                      const SizedBox(height: 40),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _fullNameController,
                              label: 'Full Name',
                              iconPath: 'assets/icons/user.png',
                              validator: (v) =>
                                  v!.isEmpty ? 'Enter full name' : null,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: _usernameController,
                              label: 'Username',
                              iconPath: 'assets/icons/user.png',
                              validator: (v) =>
                                  v!.isEmpty ? 'Enter username' : null,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: _emailController,
                              label: 'Email',
                              iconPath: 'assets/icons/email.png',
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) =>
                                  !v!.contains('@') ? 'Invalid email' : null,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: obscurePassword,
                              decoration:
                                  _inputDecoration(
                                    label: 'Password',
                                    iconPath: 'assets/icons/password.png',
                                  ).copyWith(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: AppColors.textLightGrey,
                                      ),
                                      onPressed: () =>
                                          ref
                                                  .read(
                                                    passwordVisibilityProvider
                                                        .notifier,
                                                  )
                                                  .state =
                                              !obscurePassword,
                                    ),
                                  ),
                              style: AppStyles.body,
                              validator: (v) =>
                                  v!.length < 6 ? 'Min 6 characters' : null,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: _phoneNumberController,
                              label: 'Phone Number',
                              iconPath: 'assets/icons/phone.png',
                              keyboardType: TextInputType.phone,
                              validator: (v) =>
                                  v!.isEmpty ? 'Enter phone number' : null,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: _addressController,
                              label: 'Address',
                              iconPath: 'assets/icons/address.png',
                            ),
                            const SizedBox(height: 50),
                            state.isLoading
                                ? const CircularProgressIndicator(
                                    color: AppColors.primaryOrange,
                                  )
                                : ElevatedButton(
                                    onPressed: _handleSignup,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryOrange,
                                      foregroundColor: AppColors.primaryWhite,
                                      minimumSize: const Size(230, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      "Signup",
                                      style: AppStyles.button.copyWith(
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",
                                  style: AppStyles.small.copyWith(
                                    color: AppColors.textDarkGrey,
                                    fontSize: 16,
                                  ),
                                ),
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColors.primaryBlue,
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

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      final authEntity = AuthEntity(
        userId: null,
        fullName: _fullNameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        password: _passwordController.text.trim(),
        location: _addressController.text.trim(),
        role: 'User',
      );
      await ref.read(authViewModelProvider.notifier).registerUser(authEntity);
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String iconPath,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label: label, iconPath: iconPath),
      style: AppStyles.body,
      validator: validator,
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String iconPath,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.backgroundGrey.withOpacity(0.45),
      labelText: label,
      labelStyle: AppStyles.inputLabel,
      hintStyle: AppStyles.inputLabel,
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
        borderSide: const BorderSide(color: AppColors.primaryOrange, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    );
  }
}
