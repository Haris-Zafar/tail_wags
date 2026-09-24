import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_paths.dart';
import '../../../core/widgets/placeholder_screen.dart';

/// Stub for now — grid/list of EventCards + the filter bottom sheet are
/// built in Phase 4, step 15.
class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Features',
      subtitle: 'All events (with filter icon) go here.',
      nextLabel: 'Create event (test)',
      onNext: () => context.goNamed(RoutePaths.createEvent),
    );
  }
}
