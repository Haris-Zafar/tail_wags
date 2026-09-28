import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/providers/onboarding_provider.dart';
import '../../core/router/route_paths.dart';
import '../../core/theme/app_colors.dart';

/// The first Flutter route (distinct from the OS-level native splash).
/// Pauses briefly and redirects based on auth and onboarding state.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    final user = ref.read(authStateProvider).value;
    if (user != null) {
      context.goNamed(RoutePaths.home);
      return;
    }

    final hasSeenOnboarding = await ref.read(hasSeenOnboardingProvider.future);
    if (!mounted) return;

    if (hasSeenOnboarding) {
      context.goNamed(RoutePaths.login);
    } else {
      context.goNamed(RoutePaths.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 120,
          height: 120,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.pets,
            size: 96,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
