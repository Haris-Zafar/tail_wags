import 'package:cloud_firestore/cloud_firestore.dart';

class AppUserModel {
  const AppUserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.photoAsset = 'assets/images/person.png',
    this.role = 'user',
    this.likedEventIds = const [],
  });

  final String uid;
  final String email;
  final String username;
  final String photoAsset;
  final String role; // 'user' | 'admin'
  final List<String> likedEventIds;

  bool get isAdmin => role == 'admin';

  factory AppUserModel.fromMap(Map<String, dynamic> map, String uid) {
    return AppUserModel(
      uid: uid,
      email: map['email'] as String? ?? '',
      username: map['username'] as String? ?? '',
      photoAsset: map['photoAsset'] as String? ?? 'assets/images/person.png',
      role: map['role'] as String? ?? 'user',
      likedEventIds: List<String>.from(map['likedEventIds'] as List? ?? const []),
    );
  }

  factory AppUserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return AppUserModel.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'photoAsset': photoAsset,
      'role': role,
      'likedEventIds': likedEventIds,
    };
  }

  AppUserModel copyWith({
    String? email,
    String? username,
    String? photoAsset,
    String? role,
    List<String>? likedEventIds,
  }) {
    return AppUserModel(
      uid: uid,
      email: email ?? this.email,
      username: username ?? this.username,
      photoAsset: photoAsset ?? this.photoAsset,
      role: role ?? this.role,
      likedEventIds: likedEventIds ?? this.likedEventIds,
    );
  }
}
