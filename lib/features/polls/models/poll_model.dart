import 'package:cloud_firestore/cloud_firestore.dart';

class PollModel {
  const PollModel({
    required this.id,
    required this.question,
    required this.optionA,
    required this.optionB,
    this.votesA = 12000,
    this.votesB = 12000,
    this.imageAsset = 'assets/images/event.png',
    this.groupId = '',
    this.createdBy = '',
    this.createdAt,
    this.votedUserIds = const {},
  });

  final String id;
  final String question;
  final String optionA;
  final String optionB;
  final int votesA;
  final int votesB;
  final String imageAsset;
  final String groupId;
  final String createdBy;
  final DateTime? createdAt;
  final Map<String, String> votedUserIds; // uid -> 'A' or 'B'

  factory PollModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      if (val is DateTime) return val;
      return DateTime.now();
    }

    return PollModel(
      id: id,
      question: map['question'] as String? ?? '',
      optionA: map['optionA'] as String? ?? '',
      optionB: map['optionB'] as String? ?? '',
      votesA: (map['votesA'] as num?)?.toInt() ?? 0,
      votesB: (map['votesB'] as num?)?.toInt() ?? 0,
      imageAsset: map['imageAsset'] as String? ?? 'assets/images/event.png',
      groupId: map['groupId'] as String? ?? '',
      createdBy: map['createdBy'] as String? ?? '',
      createdAt: map['createdAt'] != null ? parseDate(map['createdAt']) : null,
      votedUserIds: Map<String, String>.from(map['votedUserIds'] as Map? ?? {}),
    );
  }

  factory PollModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return PollModel.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'optionA': optionA,
      'optionB': optionB,
      'votesA': votesA,
      'votesB': votesB,
      'imageAsset': imageAsset,
      'groupId': groupId,
      'createdBy': createdBy,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'votedUserIds': votedUserIds,
    };
  }
}
