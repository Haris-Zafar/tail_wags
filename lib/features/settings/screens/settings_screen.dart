import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/widgets/placeholder_screen.dart';

/// Stub for now — profile image/email/username, edit-username tile,
/// dark-theme toggle, logout, and notifications tile are built in
/// Phase 5, step 19.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Settings',
      nextLabel: 'Edit username (test)',
      onNext: () => context.goNamed(RoutePaths.editUsername),
    );
  }
}
