import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  const EventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.detail,
    this.imageAsset = 'assets/images/event.png',
    this.groupId = '',
    this.createdBy = '',
    this.createdAt,
  });

  final String id;
  final String title;
  final DateTime date;
  final String time;
  final String location;
  final String detail;
  final String imageAsset;
  final String groupId;
  final String createdBy;
  final DateTime? createdAt;

  factory EventModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      if (val is DateTime) return val;
      return DateTime.now();
    }

    return EventModel(
      id: id,
      title: map['title'] as String? ?? '',
      date: parseDate(map['date']),
      time: map['time'] as String? ?? '',
      location: map['location'] as String? ?? '',
      detail: map['detail'] as String? ?? '',
      imageAsset: map['imageAsset'] as String? ?? 'assets/images/event.png',
      groupId: map['groupId'] as String? ?? '',
      createdBy: map['createdBy'] as String? ?? '',
      createdAt: map['createdAt'] != null ? parseDate(map['createdAt']) : null,
    );
  }

  factory EventModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return EventModel.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': Timestamp.fromDate(date),
      'time': time,
      'location': location,
      'detail': detail,
      'imageAsset': imageAsset,
      'groupId': groupId,
      'createdBy': createdBy,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  EventModel copyWith({
    String? title,
    DateTime? date,
    String? time,
    String? location,
    String? detail,
    String? imageAsset,
    String? groupId,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return EventModel(
      id: id,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      detail: detail ?? this.detail,
      imageAsset: imageAsset ?? this.imageAsset,
      groupId: groupId ?? this.groupId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
