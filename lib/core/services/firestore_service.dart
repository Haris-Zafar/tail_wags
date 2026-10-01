import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/auth/models/app_user_model.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _usersRef => _db.collection('users');

  /// Creates a user document in `users/{uid}` if it doesn't already exist.
  Future<void> createUserDoc({
    required String uid,
    required String email,
    required String username,
    String role = 'user',
  }) async {
    final docRef = _usersRef.doc(uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      final newUser = AppUserModel(
        uid: uid,
        email: email,
        username: username.isNotEmpty ? username : email.split('@').first,
        role: role,
      );
      await docRef.set(newUser.toMap());
    }
  }

  /// Get user document as Stream
  Stream<AppUserModel?> userStream(String uid) {
    if (uid.isEmpty) return Stream.value(null);
    return _usersRef.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return AppUserModel.fromDocument(doc);
    });
  }

  /// Get user document once
  Future<AppUserModel?> getUserDoc(String uid) async {
    if (uid.isEmpty) return null;
    final doc = await _usersRef.doc(uid).get();
    if (!doc.exists) return null;
    return AppUserModel.fromDocument(doc);
  }

  /// Update username
  Future<void> updateUsername(String uid, String newUsername) async {
    await _usersRef.doc(uid).update({'username': newUsername});
  }

  /// Update user profile photo URL
  Future<void> updateProfilePhoto(String uid, String photoUrl) async {
    await _usersRef.doc(uid).update({
      'photoUrl': photoUrl,
      'photoAsset': photoUrl,
    });
  }
}
