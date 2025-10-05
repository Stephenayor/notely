import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../domain/user_repository.dart';
import '../model/user_profile.dart';

@lazySingleton
class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> saveUserProfile(String uid, UserProfile profile) async {
    try {
      await _firestore.collection("Note users").doc(uid).set(profile.toMap());
    } on FirebaseException catch (e) {
      throw Exception("Firestore error: ${e.message}");
    } catch (e) {
      throw Exception("Failed to save user profile: $e");
    }
  }

  @override
  Future<UserCredential> signInEmailPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception("Failed to sign in with email and password: $e");
    }
  }
}
