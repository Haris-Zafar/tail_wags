import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_service.dart';
import '../../features/auth/models/app_user_model.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return FirebaseAuthService(firestoreService: firestoreService);
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthServiceProvider).authStateChanges;
});

final currentUserDocProvider = StreamProvider<AppUserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.value;
  if (user == null) return Stream.value(null);

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.userStream(user.uid);
});
