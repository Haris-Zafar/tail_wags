import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  const GroupModel({
    required this.id,
    required this.name,
    required this.description,
    this.memberCount = '14K Members',
    this.imageAsset = 'assets/images/person.png',
  });

  final String id;
  final String name;
  final String description;
  final String memberCount;
  final String imageAsset;

  factory GroupModel.fromMap(Map<String, dynamic> map, String id) {
    return GroupModel(
      id: id,
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      memberCount: map['memberCount'] as String? ?? '14K Members',
      imageAsset: map['imageAsset'] as String? ?? 'assets/images/person.png',
    );
  }

  factory GroupModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return GroupModel.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'memberCount': memberCount,
      'imageAsset': imageAsset,
    };
  }
}
