import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mind_flow/models/user.dart' as app_models;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  User? get currentUser => _auth.currentUser;

  // Sign up with email and password
  Future<app_models.User?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    final UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user == null) return null;

    final app_models.User newUser = app_models.User(
      id: credential.user!.uid,
      email: email,
      name: name,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection('users')
        .doc(credential.user!.uid)
        .set(newUser.toJson());

    return newUser;
  }

  // Sign in with email and password
  Future<app_models.User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user == null) return null;

    return await getUserProfile(credential.user!.uid);
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get user profile from Firestore
  Future<app_models.User?> getUserProfile(String uid) async {
    final DocumentSnapshot doc =
        await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) return null;

    return app_models.User.fromJson(doc.data() as Map<String, dynamic>);
  }

  // Update user profile
  Future<void> updateUserProfile(app_models.User user) async {
    await _firestore
        .collection('users')
        .doc(user.id)
        .update(user.toJson());
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Toggle favorite meditation
  Future<void> toggleFavorite(String uid, String meditationId) async {
    final DocumentReference userRef =
        _firestore.collection('users').doc(uid);

    final DocumentSnapshot doc = await userRef.get();
    if (!doc.exists) return;

    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final List<String> favorites =
        List<String>.from(data['favoriteMeditationIds'] as List? ?? []);

    if (favorites.contains(meditationId)) {
      favorites.remove(meditationId);
    } else {
      favorites.add(meditationId);
    }

    await userRef.update({'favoriteMeditationIds': favorites});
  }

  // Update meditation progress
  Future<void> updateProgress({
    required String uid,
    required String meditationId,
    required int durationSeconds,
  }) async {
    final DocumentReference userRef =
        _firestore.collection('users').doc(uid);

    final DocumentSnapshot doc = await userRef.get();
    if (!doc.exists) return;

    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final List<String> completed =
        List<String>.from(data['completedMeditationIds'] as List? ?? []);
    final int totalMinutes =
        (data['totalMeditationMinutes'] as int? ?? 0) +
            (durationSeconds ~/ 60);

    if (!completed.contains(meditationId)) {
      completed.add(meditationId);
    }

    await userRef.update({
      'completedMeditationIds': completed,
      'totalMeditationMinutes': totalMinutes,
    });
  }
}
