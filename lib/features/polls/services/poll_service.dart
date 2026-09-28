import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/poll_model.dart';

class PollService {
  PollService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _pollsRef =>
      _db.collection('polls');

  Future<String> createPoll(PollModel poll) async {
    final docRef = await _pollsRef.add(poll.toMap());
    return docRef.id;
  }

  Stream<List<PollModel>> streamPolls() {
    return _pollsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => PollModel.fromDocument(doc)).toList();
    });
  }

  Future<void> voteOnPoll({
    required String pollId,
    required String uid,
    required String option, // 'A' or 'B'
  }) async {
    final docRef = _pollsRef.doc(pollId);
    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      final data = snapshot.data()!;
      final votedUserIds = Map<String, String>.from(data['votedUserIds'] as Map? ?? {});
      final previousVote = votedUserIds[uid];

      if (previousVote == option) return; // already voted for this option

      int votesA = (data['votesA'] as num?)?.toInt() ?? 0;
      int votesB = (data['votesB'] as num?)?.toInt() ?? 0;

      if (previousVote == 'A') votesA = (votesA - 1).clamp(0, 999999);
      if (previousVote == 'B') votesB = (votesB - 1).clamp(0, 999999);

      if (option == 'A') votesA++;
      if (option == 'B') votesB++;

      votedUserIds[uid] = option;

      transaction.update(docRef, {
        'votesA': votesA,
        'votesB': votesB,
        'votedUserIds': votedUserIds,
      });
    });
  }
}
