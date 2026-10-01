// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
//
// final firebaseStorageServiceProvider = Provider<FirebaseStorageService>((ref) {
//   return FirebaseStorageService();
// });
//
// class FirebaseStorageService {
//   FirebaseStorageService({FirebaseStorage? storage})
//       : _storage = storage ?? FirebaseStorage.instance;
//
//   final FirebaseStorage _storage;
//
//   /// Uploads profile picture for [uid] to Firebase Storage
//   /// under `profile_pictures/{uid}.jpg` and returns the download URL.
//   Future<String> uploadProfilePicture({
//     required String uid,
//     required XFile imageFile,
//   }) async {
//     final ref = _storage.ref().child('profile_pictures').child('$uid.jpg');
//
//     final bytes = await imageFile.readAsBytes();
//     final metadata = SettableMetadata(contentType: 'image/jpeg');
//
//     final uploadTask = ref.putData(bytes, metadata);
//     final snapshot = await uploadTask;
//     final downloadUrl = await snapshot.ref.getDownloadURL();
//     return downloadUrl;
//   }
// }
