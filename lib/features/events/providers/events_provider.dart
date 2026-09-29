import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';

final eventServiceProvider = Provider<EventService>((ref) {
  return EventService();
});

/// Streams all created events from Firestore
final allEventsProvider = StreamProvider<List<EventModel>>((ref) {
  final eventService = ref.watch(eventServiceProvider);
  return eventService.streamEvents();
});

/// Returns only liked events for the current user
final likedEventsProvider = Provider<List<EventModel>>((ref) {
  final allEvents = ref.watch(allEventsProvider).value ?? [];
  final currentUser = ref.watch(currentUserDocProvider).value;

  if (currentUser == null) return [];
  return allEvents
      .where((event) => currentUser.likedEventIds.contains(event.id))
      .toList();
});

/// Returns events scheduled for today
final todaysEventsProvider = Provider<List<EventModel>>((ref) {
  final allEvents = ref.watch(allEventsProvider).value ?? [];
  final now = DateTime.now();

  return allEvents.where((event) {
    return event.date.year == now.year &&
        event.date.month == now.month &&
        event.date.day == now.day;
  }).toList();
});

/// Streams a single event by ID
final singleEventProvider =
    StreamProvider.family<EventModel?, String>((ref, eventId) {
  final eventService = ref.watch(eventServiceProvider);
  return eventService.streamEvent(eventId);
});
