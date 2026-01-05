import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_connect/auth/presentation/auth_viewmodel/auth_viewmodel.dart';
import 'package:pet_connect/auth/presentation/state/auth_state.dart';
import 'package:pet_connect/auth/presentation/view/register_view.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/core/utils/snackbar_utils.dart';
import 'package:pet_connect/home/homescreen.dart';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.message != null) {
        showSnackBar(
          context: context,
          message: next.message!,
          isSuccess: !next.isError,
        );

        if (!next.isError && next.message == 'Login Successful') {
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          });
        }
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
                        width: 200,
                        height: 200,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/petConnect.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Text('Welcome Back', style: AppStyles.headline2),
                      Text(
                        'Please enter your details',
                        style: AppStyles.subtitle,
                      ),
                      const SizedBox(height: 40),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Email field
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
                            const SizedBox(height: 20),

                            // Password field
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
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Forgot password?',
                                style: GoogleFonts.alice(
                                  fontSize: 16,
                                  color: AppColors.errorRed,
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),

                            // Login Button or Loader
                            state.isLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        ref
                                            .read(
                                              authViewModelProvider.notifier,
                                            )
                                            .loginUser(
                                              _emailController.text.trim(),
                                              _passwordController.text.trim(),
                                            );
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
                                      "Login",
                                      style: GoogleFonts.alice(
                                        fontSize: 25,
                                        color: AppColors.primaryWhite,
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 10),

                            // Signup link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
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
                                      builder: (context) =>
                                          const SignupScreen(),
                                    ),
                                  ),
                                  child: Text(
                                    "Signup!",
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
