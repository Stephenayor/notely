import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/model/user_profile.dart';

abstract class UserRepository {
  Future<void> saveUserProfile(String uid, UserProfile profile);
  Future<UserCredential> signInEmailPassword(String email, String password);
}
