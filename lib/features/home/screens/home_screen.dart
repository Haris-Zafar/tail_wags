import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/widgets/placeholder_screen.dart';

/// Stub for now — list view (today's events) then calendar view
/// (table_calendar with dot markers) are built in Phase 4, step 12.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Home',
      subtitle: 'List view / calendar view of today\'s events go here.',
      nextLabel: 'Open event detail (test)',
      onNext: () => context.pushNamed(
        RoutePaths.eventDetail,
        pathParameters: {'eventId': 'demo-id'},
      ),
    );
  }
}
