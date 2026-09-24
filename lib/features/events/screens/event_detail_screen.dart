import 'package:flutter/material.dart';

import '../../../core/widgets/placeholder_screen.dart';

/// Stub for now — full detail view + "add to calendar" button are built
/// in Phase 4, step 14.
class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Event Detail',
      subtitle: 'eventId: $eventId',
    );
  }
}
