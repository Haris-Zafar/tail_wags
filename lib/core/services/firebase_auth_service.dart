import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firestore_service.dart';

class FirebaseAuthService {
  FirebaseAuthService({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
    FirestoreService? firestoreService,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
        _firestoreService = firestoreService ?? FirestoreService();

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FirestoreService _firestoreService;
  bool _isGoogleSignInInitialized = false;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isGoogleSignInInitialized) {
      await _googleSignIn.initialize(
        serverClientId:
            '536162640690-f6rl7autnkp20hlnmjepr9sq6mqp5k48.apps.googleusercontent.com',
      );
      _isGoogleSignInInitialized = true;
    }
  }

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    String? username,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    if (credential.user != null) {
      final uid = credential.user!.uid;
      final derivedName = username ?? email.split('@').first;
      await _firestoreService.createUserDoc(
        uid: uid,
        email: email.trim(),
        username: derivedName,
      );
    }

    return credential;
  }

  Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    await _ensureGoogleSignInInitialized();

    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final user = userCredential.user!;
        await _firestoreService.createUserDoc(
          uid: user.uid,
          email: user.email ?? '',
          username: user.displayName ?? user.email?.split('@').first ?? 'User',
        );
      }

      return userCredential;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        // User canceled sign-in
        return null;
      }
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // Ignore sign out errors if user wasn't signed in via Google
    }
    await _auth.signOut();
  }
}
