import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/widgets/placeholder_screen.dart';

/// Stub for now — real form + Firebase Auth wiring happens in Phase 2,
/// steps 8–9.
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Sign Up',
      nextLabel: 'Continue to app (test)',
      onNext: () => context.goNamed(RoutePaths.home),
    );
  }
}
