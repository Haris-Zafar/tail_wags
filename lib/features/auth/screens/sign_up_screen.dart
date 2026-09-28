import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/google_sign_in_button.dart';
import '../../../core/widgets/loading_button.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(firebaseAuthServiceProvider);
      await authService.signUpWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;
      context.goNamed(RoutePaths.home);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Sign up failed. Please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An unexpected error occurred. Please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isGoogleLoading = true);

    try {
      final authService = ref.read(firebaseAuthServiceProvider);
      final credential = await authService.signInWithGoogle();

      if (credential != null && mounted) {
        context.goNamed(RoutePaths.home);
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Google Sign-In failed.'),
          backgroundColor: AppColors.error,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google Sign-In failed. Please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),

                    // Title
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Create ',
                            style: AppTextStyles.headline.copyWith(
                              color: AppColors.primary,
                              fontSize: 28,
                            ),
                          ),
                          TextSpan(
                            text: 'Account',
                            style: AppTextStyles.headline.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'Enter given detail to create your account',
                      style: AppTextStyles.caption.copyWith(fontSize: 14),
                    ),

                    const SizedBox(height: 32),

                    // Email Field
                    AppTextField(
                      label: 'Email',
                      controller: _emailController,
                      hint: 'Example23@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: Validators.email,
                      autofillHints: const [AutofillHints.email],
                    ),

                    const SizedBox(height: 16),

                    // Password Field
                    AppTextField(
                      label: 'Password',
                      controller: _passwordController,
                      hint: '************',
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      validator: Validators.password,
                    ),

                    const SizedBox(height: 16),

                    // Confirm Password Field
                    AppTextField(
                      label: 'Confirm Password',
                      controller: _confirmPasswordController,
                      hint: '************',
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      validator: Validators.confirmPassword(
                        () => _passwordController.text,
                      ),
                      onFieldSubmitted: (_) => _handleSignUp(),
                    ),

                    const SizedBox(height: 24),

                    // Continue Button
                    LoadingButton(
                      label: 'Continue',
                      isLoading: _isLoading,
                      onPressed: _handleSignUp,
                    ),

                    const SizedBox(height: 24),

                    // Divider OR
                    Center(
                      child: Text(
                        'OR',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Google Sign-In Button
                    GoogleSignInButton(
                      onPressed: _handleGoogleSignIn,
                      isLoading: _isGoogleLoading,
                    ),

                    const SizedBox(height: 32),

                    // Footer Link to Login
                    Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'If you have an account ',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            TextSpan(
                              text: 'Login',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => context.goNamed(RoutePaths.login),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
