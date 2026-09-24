import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/route_paths.dart';
import '../../core/widgets/placeholder_screen.dart';

/// Stub for now — real UI (PageView + smooth_page_indicator +
/// skip/next/get-started) is built in Phase 2, step 7.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Onboarding',
      nextLabel: 'Get started',
      onNext: () => context.goNamed(RoutePaths.login),
    );
  }
}
