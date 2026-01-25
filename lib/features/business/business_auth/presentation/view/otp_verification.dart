import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/core/utils/snackbar_utils.dart';
import 'package:pet_connect/features/business/business_auth/presentation/auth_viewmodel/auth_viewmodel.dart';
import 'package:pet_connect/features/business/business_auth/presentation/state/auth_state.dart';
import 'package:pet_connect/features/business/business_auth/presentation/view/upload_document.dart';

class BusinessOtpVerificationScreen extends ConsumerStatefulWidget {
  const BusinessOtpVerificationScreen({super.key});

  @override
  ConsumerState<BusinessOtpVerificationScreen> createState() =>
      _BusinessOtpVerificationScreenState();
}

class _BusinessOtpVerificationScreenState
    extends ConsumerState<BusinessOtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ref.listen<BusinessState>(businessViewModelProvider, (previous, next) {
      if (previous?.isLoading == true && next.isLoading == false) {
        if (next.message != null) {
          showSnackBar(
            context: context,
            message: next.message!,
            isSuccess: !next.isError,
          );
        }
        if (next.flow == BusinessFlow.otpVerified) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const UploadBusinessDocument()),
          );
        }
      }
    });

    final state = ref.watch(businessViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 60),
                Center(
                  child: Image.asset(
                    'assets/images/petConnect.png',
                    width: 120,
                  ),
                ),
                const SizedBox(height: 30),
                Text("Verify Your Email", style: AppStyles.headline3),
                const SizedBox(height: 10),
                Text(
                  "Enter the 4-digit code sent to\n${state.email ?? 'your email'}",
                  textAlign: TextAlign.center,
                  style: AppStyles.subtitle,
                ),
                const SizedBox(height: 40),

                // Adjusted for 4 Digits
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 4, // Updated to 4
                  style: AppStyles.headline3.copyWith(
                    letterSpacing: 25,
                    fontSize: 32,
                  ),
                  decoration: InputDecoration(
                    counterText: "",
                    filled: true,
                    fillColor: AppColors.backgroundGrey.withOpacity(0.45),
                    hintText: "0000", // Updated hint
                    hintStyle: AppStyles.subtitle.copyWith(
                      letterSpacing: 25,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primaryOrange,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) => (value == null || value.length < 4)
                      ? "Enter 4 digits"
                      : null,
                ),

                const SizedBox(height: 40),
                state.isLoading
                    ? const CircularProgressIndicator(
                        color: AppColors.primaryOrange,
                      )
                    : ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ref
                                .read(businessViewModelProvider.notifier)
                                .verifyOtp(_otpController.text.trim());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text("Verify Account", style: AppStyles.button),
                      ),

                const SizedBox(height: 24),
                TextButton(
                  onPressed: state.isLoading
                      ? null
                      : () => ref
                            .read(businessViewModelProvider.notifier)
                            .resendOtp(),
                  child: Text(
                    "Resend Code",
                    style: AppStyles.linkText.copyWith(
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
