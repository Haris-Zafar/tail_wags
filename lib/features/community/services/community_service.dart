import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/group_model.dart';

final communityServiceProvider = Provider<CommunityService>((ref) {
  return CommunityService();
});

class CommunityService {
  CommunityService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _groupsRef =>
      _db.collection('groups');

  Stream<List<GroupModel>> streamGroups() {
    return _groupsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => GroupModel.fromDocument(doc)).toList();
    });
  }
}
