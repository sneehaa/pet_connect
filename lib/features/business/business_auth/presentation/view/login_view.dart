import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/core/utils/snackbar_utils.dart';
import 'package:pet_connect/features/business/business_auth/presentation/auth_viewmodel/auth_viewmodel.dart';
import 'package:pet_connect/features/business/business_auth/presentation/state/auth_state.dart';
import 'package:pet_connect/features/business/business_auth/presentation/view/register_view.dart';
import 'package:pet_connect/features/business/business_auth/presentation/view/upload_document.dart';
import 'package:pet_connect/features/business/business_dashboard/presentation/view/business_dashboard.dart';

// Local provider for password visibility toggle
final businessLoginPasswordVisibleProvider = StateProvider.autoDispose<bool>(
  (ref) => true,
);

class BusinessLoginScreen extends ConsumerStatefulWidget {
  const BusinessLoginScreen({super.key});

  @override
  ConsumerState<BusinessLoginScreen> createState() =>
      _BusinessLoginScreenState();
}

class _BusinessLoginScreenState extends ConsumerState<BusinessLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final obscurePassword = ref.watch(businessLoginPasswordVisibleProvider);
    final state = ref.watch(businessViewModelProvider);

    ref.listen<BusinessState>(businessViewModelProvider, (previous, next) {
      if (next.message != null && previous?.message != next.message) {
        showSnackBar(
          context: context,
          message: next.message!,
          isSuccess: !next.isError,
        );

        if (next.isError) {
          if (next.message!.toLowerCase().contains('not approved') ||
              next.message!.toLowerCase().contains('pending')) {
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) _showDocumentUploadDialog();
            });
          }
        } else if (next.flow == BusinessFlow.loggedIn ||
            next.message == 'Login successful') {
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const BusinessDashboardScreen(),
                ),
              );
            }
          });
        }
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
                        width: 200,
                        height: 200,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/petConnect.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Text('Business Login', style: AppStyles.headline2),
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
                              controller: _emailController,
                              label: 'Email',
                              iconPath: 'assets/icons/email.png',
                              validator: (v) =>
                                  v!.isEmpty ? 'Enter email/username' : null,
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
                                                    businessLoginPasswordVisibleProvider
                                                        .notifier,
                                                  )
                                                  .state =
                                              !obscurePassword,
                                    ),
                                  ),
                              validator: (v) =>
                                  v!.length < 6 ? 'Min 6 characters' : null,
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Forgot password?',
                                style: AppStyles.linkText.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            state.isLoading
                                ? const CircularProgressIndicator(
                                    color: AppColors.primaryOrange,
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        ref
                                            .read(
                                              businessViewModelProvider
                                                  .notifier,
                                            )
                                            .loginBusiness(
                                              _emailController.text.trim(),
                                              _passwordController.text.trim(),
                                            );
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
                                      "Login",
                                      style: AppStyles.button.copyWith(
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: AppStyles.small.copyWith(fontSize: 16),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const BusinessSignupScreen(),
                                    ),
                                  ),
                                  child: Text(
                                    "Signup!",
                                    style: AppStyles.linkText.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            TextButton.icon(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const UploadBusinessDocument(),
                                ),
                              ),
                              icon: const Icon(
                                Icons.upload_file,
                                color: AppColors.primaryOrange,
                                size: 20,
                              ),
                              label: Text(
                                'Upload Documents',
                                style: AppStyles.button.copyWith(
                                  color: AppColors.primaryOrange,
                                  fontSize: 14,
                                ),
                              ),
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
    required String label,
    required String iconPath,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label: label, iconPath: iconPath),
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
      labelStyle: AppStyles.subtitle.copyWith(fontSize: 18),
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.asset(iconPath, width: 24, height: 24),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    );
  }

  void _showDocumentUploadDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.primaryOrange,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Documents Required', style: AppStyles.headline3),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your business registration is pending. You need to upload verification documents before you can login.',
                style: AppStyles.body,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Required Documents:',
                      style: AppStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildRequirementItem('Business registration certificate'),
                    _buildRequirementItem('Tax documents'),
                    _buildRequirementItem('Owner ID proof'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Later',
                style: AppStyles.small.copyWith(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UploadBusinessDocument(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
              ),
              child: Text(
                'Upload Now',
                style: AppStyles.button.copyWith(fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 16,
            color: AppColors.primaryOrange,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppStyles.small.copyWith(color: AppColors.textBlack),
            ),
          ),
        ],
      ),
    );
  }
}
