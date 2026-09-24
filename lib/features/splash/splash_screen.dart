import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/route_paths.dart';
import '../../core/theme/app_colors.dart';

/// The first Flutter route (distinct from the OS-level native splash
/// configured via flutter_native_splash in pubspec.yaml — that one covers
/// the gap before the Flutter engine has even attached).
///
/// This is where startup work happens: for now it just pauses briefly and
/// moves on to onboarding.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    // TODO (Phase 2, step 9): replace this with a real check —
    // watch authStateProvider and go straight to /home if already signed
    // in, /login if not, and only show onboarding on first launch
    // (e.g. a "hasSeenOnboarding" flag via shared_preferences).
    context.goNamed(RoutePaths.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        // Swap for the real logo once it's added to assets/images/.
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
