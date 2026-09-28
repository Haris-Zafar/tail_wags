import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';

final eventServiceProvider = Provider<EventService>((ref) {
  return EventService();
});

/// Sample fallback events so the UI is populated out-of-the-box for MVP testing
final sampleEvents = [
  EventModel(
    id: 'sample-1',
    title: 'Made in Melanin! Black History Month Social.....',
    date: DateTime(2025, 10, 28, 18, 0),
    time: '28 October 2025 6:00pm GMT',
    location: '1901 Thornridge Cir. Shiloh, Hawaii 81063',
    detail:
        'Join us for a vibrant celebration of culture, community, and connection at the Made in Melanin Social.',
    imageAsset: 'assets/images/event.png',
  ),
  EventModel(
    id: 'sample-2',
    title: 'TailWags Community Meetup & Dog Playdate',
    date: DateTime.now(),
    time: 'Today 4:00pm GMT',
    location: 'Central Park Bark Area, NY 10024',
    detail:
        'Bring your pets and connect with fellow pet parents in the community for an afternoon of fun activities.',
    imageAsset: 'assets/images/event.png',
  ),
  EventModel(
    id: 'sample-3',
    title: 'Annual Pet Tech & Innovation Expo 2025',
    date: DateTime(2025, 11, 15, 10, 0),
    time: '15 November 2025 10:00am GMT',
    location: 'Convention Center, San Francisco, CA 94103',
    detail:
        'Discover the latest innovations, apps, and health technology for pets and animal lovers.',
    imageAsset: 'assets/images/event.png',
  ),
];

/// Streams all events from Firestore; falls back to [sampleEvents] if empty
final allEventsProvider = StreamProvider<List<EventModel>>((ref) {
  final eventService = ref.watch(eventServiceProvider);
  return eventService.streamEvents().map((events) {
    if (events.isEmpty) {
      return sampleEvents;
    }
    return events;
  });
});

/// Returns only liked events for the current user
final likedEventsProvider = Provider<List<EventModel>>((ref) {
  final allEvents = ref.watch(allEventsProvider).value ?? sampleEvents;
  final currentUser = ref.watch(currentUserDocProvider).value;

  if (currentUser == null) return [];
  return allEvents
      .where((event) => currentUser.likedEventIds.contains(event.id))
      .toList();
});

/// Returns events scheduled for today
final todaysEventsProvider = Provider<List<EventModel>>((ref) {
  final allEvents = ref.watch(allEventsProvider).value ?? sampleEvents;
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
  return eventService.streamEvent(eventId).map((event) {
    if (event == null) {
      return sampleEvents.firstWhere(
        (e) => e.id == eventId,
        orElse: () => sampleEvents.first,
      );
    }
    return event;
  });
});
