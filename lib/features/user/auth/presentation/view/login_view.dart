import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/core/utils/snackbar_utils.dart';
import 'package:pet_connect/features/user/auth/presentation/auth_viewmodel/auth_viewmodel.dart';
import 'package:pet_connect/features/user/auth/presentation/state/auth_state.dart';
import 'package:pet_connect/features/user/auth/presentation/view/register_view.dart';
import 'package:pet_connect/features/user/home/homescreen.dart';

// Local provider for password visibility
final loginPasswordVisibleProvider = StateProvider.autoDispose<bool>(
  (ref) => true,
);

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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final obscurePassword = ref.watch(loginPasswordVisibleProvider);
    final state = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.message != null && previous?.message != next.message) {
        showSnackBar(
          context: context,
          message: next.message!,
          isSuccess: !next.isError,
        );

        if (!next.isError && next.flow == AuthFlow.authenticated) {
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const Homescreen()),
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
                            // Email Field
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _inputDecoration(
                                label: 'Email',
                                iconPath: 'assets/icons/email.png',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Please enter email';
                                if (!value.contains('@'))
                                  return 'Invalid email format';
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Password Field with Toggle
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
                                                    loginPasswordVisibleProvider
                                                        .notifier,
                                                  )
                                                  .state =
                                              !obscurePassword,
                                    ),
                                  ),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Please enter password';
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  /* Handle forgot password */
                                },
                                child: Text(
                                  'Forgot password?',
                                  style: AppStyles.linkText.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),

                            // Login Button
                            state.isLoading
                                ? const CircularProgressIndicator(
                                    color: AppColors.primaryOrange,
                                  )
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

                            // Signup Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: AppStyles.small.copyWith(
                                    fontSize: 16,
                                    color: AppColors.textDarkGrey,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SignupScreen(),
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
}
