import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/widgets/placeholder_screen.dart';

/// Stub for now — real form, email/password + Google sign-in, and
/// forgot-password link happen in Phase 2, steps 8–9.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Login',
      nextLabel: 'Continue to app (test)',
      onNext: () => context.goNamed(RoutePaths.home),
    );
  }
}
