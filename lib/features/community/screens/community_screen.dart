import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/widgets/placeholder_screen.dart';

/// Stub for now — custom app bar with group name, list of groups, and
/// admin-only create-event/create-poll floating buttons are built in
/// Phase 4, step 18.
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Community',
      nextLabel: 'Open group profile (test)',
      onNext: () => context.pushNamed(
        RoutePaths.groupProfile,
        pathParameters: {'groupId': 'demo-group'},
      ),
    );
  }
}
