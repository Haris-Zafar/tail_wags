import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _hasSeenOnboardingKey = 'has_seen_onboarding';

/// Resolves once at startup to whether this device has completed
/// onboarding before. `SplashScreen` reads this (alongside auth state) to
/// decide whether a signed-out user goes to onboarding or straight to login.
final hasSeenOnboardingProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_hasSeenOnboardingKey) ?? false;
});

/// Call from the onboarding screen's Skip/Get Started action, then
/// invalidate `hasSeenOnboardingProvider` if you need to re-read it in the
/// same session (SplashScreen only reads it once per cold start, so this
/// alone is enough for the normal flow).
Future<void> markOnboardingSeen() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_hasSeenOnboardingKey, true);
}
