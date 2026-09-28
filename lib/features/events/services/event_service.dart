import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class EventService {
  EventService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _eventsRef =>
      _db.collection('events');

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _db.collection('users');

  /// Creates a new event document in Firestore
  Future<String> createEvent(EventModel event) async {
    final docRef = await _eventsRef.add(event.toMap());
    return docRef.id;
  }

  /// Streams all events ordered by date ascending
  Stream<List<EventModel>> streamEvents() {
    return _eventsRef.snapshots().map((snapshot) {
      final events = snapshot.docs
          .map((doc) => EventModel.fromDocument(doc))
          .toList();
      events.sort((a, b) => a.date.compareTo(b.date));
      return events;
    });
  }

  /// Streams a single event by ID
  Stream<EventModel?> streamEvent(String id) {
    if (id.isEmpty) return Stream.value(null);
    return _eventsRef.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return EventModel.fromDocument(doc);
    });
  }

  /// Toggle like/favorite status of an event for a specific user
  Future<void> toggleLikeEvent({
    required String uid,
    required String eventId,
    required bool isLiked,
  }) async {
    if (uid.isEmpty || eventId.isEmpty) return;

    final userRef = _usersRef.doc(uid);

    if (isLiked) {
      await userRef.update({
        'likedEventIds': FieldValue.arrayRemove([eventId]),
      });
    } else {
      await userRef.update({
        'likedEventIds': FieldValue.arrayUnion([eventId]),
      });
    }
  }
}
