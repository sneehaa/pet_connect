import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_connect/auth/domain/entity/auth_entity.dart';
import 'package:pet_connect/auth/presentation/auth_viewmodel/auth_viewmodel.dart';
import 'package:pet_connect/auth/presentation/state/auth_state.dart';
import 'package:pet_connect/auth/presentation/view/login_view.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/core/utils/snackbar_utils.dart';

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
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
     
      if (next.message == null ||
          (previous?.isLoading == true && next.isLoading == false)) {
        if (next.message != null) {
          showSnackBar(
            context: context,
            message: next.message!,
            isSuccess: !next.isError,
          );
        }
      }

      if (!next.isError && next.message == 'User Registered Successfully') {
        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
          ref.read(authViewModelProvider.notifier).reset();
        });
      } else if (next.isError) {
        // Reset only on error, after showing snackbar
        ref.read(authViewModelProvider.notifier).reset();
      }
    });

    final state = ref.watch(authViewModelProvider);

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
                      Text('Create your Account', style: AppStyles.headline2),
                      Text(
                        'Please enter your details',
                        style: AppStyles.subtitle,
                      ),
                      const SizedBox(height: 40),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _fullNameController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.backgroundGrey.withOpacity(
                                  0.45,
                                ),
                                labelText: 'Full Name',
                                labelStyle: GoogleFonts.alice(
                                  fontSize: 18,
                                  color: AppColors.textLightGrey,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset(
                                    'assets/icons/user.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 18,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.backgroundGrey.withOpacity(
                                  0.45,
                                ),
                                labelText: 'Username',
                                labelStyle: GoogleFonts.alice(
                                  fontSize: 18,
                                  color: AppColors.textLightGrey,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset(
                                    'assets/icons/user.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 18,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a username';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.backgroundGrey.withOpacity(
                                  0.45,
                                ),
                                labelText: 'Email',
                                labelStyle: GoogleFonts.alice(
                                  fontSize: 18,
                                  color: AppColors.textLightGrey,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset(
                                    'assets/icons/email.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 18,
                                ),
                              ),
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
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.backgroundGrey.withOpacity(
                                  0.45,
                                ),
                                labelText: 'Password',
                                labelStyle: GoogleFonts.alice(
                                  fontSize: 18,
                                  color: AppColors.textLightGrey,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset(
                                    'assets/icons/password.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 18,
                                ),
                              ),
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
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _phoneNumberController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.backgroundGrey.withOpacity(
                                  0.45,
                                ),
                                labelText: 'Phone Number',
                                labelStyle: GoogleFonts.alice(
                                  fontSize: 18,
                                  color: AppColors.textLightGrey,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset(
                                    'assets/icons/phone.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 18,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.backgroundGrey.withOpacity(
                                  0.45,
                                ),
                                labelText: 'Address',
                                labelStyle: GoogleFonts.alice(
                                  fontSize: 18,
                                  color: AppColors.textLightGrey,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset(
                                    'assets/icons/address.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 18,
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            state.isLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        final authEntity = AuthEntity(
                                          userId: null,
                                          fullName: _fullNameController.text
                                              .trim(),
                                          username: _usernameController.text
                                              .trim(),
                                          email: _emailController.text.trim(),
                                          phoneNumber: _phoneNumberController
                                              .text
                                              .trim(),
                                          password: _passwordController.text
                                              .trim(),
                                          location: _addressController.text
                                              .trim(),
                                          role: 'User',
                                        );

                                        await ref
                                            .read(
                                              authViewModelProvider.notifier,
                                            )
                                            .registerUser(authEntity);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryOrange,
                                      minimumSize: const Size(230, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      "Signup",
                                      style: GoogleFonts.alice(
                                        fontSize: 25,
                                        color: AppColors.primaryWhite,
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: GoogleFonts.alice(
                                    fontSize: 16,
                                    color: AppColors.textDarkGrey,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  ),
                                  child: Text(
                                    "Login!",
                                    style: GoogleFonts.alice(
                                      fontSize: 16,
                                      color: AppColors.errorRed,
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
}
