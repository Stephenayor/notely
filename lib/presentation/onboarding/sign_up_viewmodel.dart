import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:notely/presentation/notes/notes_base_viewmodel.dart';
import 'package:uuid/uuid.dart';
import '../../data/model/user_profile.dart';
import '../../domain/user_repository.dart';

class SignUpViewmodel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _repository;

  SignUpViewmodel(this._repository);
  bool isLoading = false;
  String? errorMessage;

  Future<User?> signUpWithGoogle() async {
    try {
      isLoading = true;
      notifyListeners();

      final googleProvider = GoogleAuthProvider();
      final userCredential = await _auth.signInWithPopup(googleProvider);
      final user = userCredential.user;

      if (user != null) {
        final profile = UserProfile(
          id: const Uuid().v4(),
          email: user.email ?? "",
          name: user.displayName ?? "",
          password: "", // Google sign-in doesn't provide password
          joinDate: DateTime.now(),
        );
        await _repository.saveUserProfile(user.uid, profile);
      }

      return user;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveUserProfile(
    User firebaseUser,
    UserProfile userProfile,
  ) async {
    try {
      isLoading = true;
      notifyListeners();
      return await _repository.saveUserProfile(firebaseUser.uid, userProfile);
    } catch (e) {
      errorMessage = e.toString();
      return;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<User?> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    try {
      _setLoading(true);
      notifyListeners();

      final firebaseUserCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = firebaseUserCredential.user;

      if (firebaseUser != null) {
        final profile = UserProfile(
          id: const Uuid().v4(),
          email: email,
          name: name,
          password: password,
          joinDate: DateTime.now(),
        );
        await _repository.saveUserProfile(firebaseUser.uid, profile);
      }

      return firebaseUser;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "This email is already registered.";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email address.";
          break;
        case 'weak-password':
          errorMessage = "Password is too weak.";
          break;
        default:
          errorMessage = e.message ?? "Signup failed.";
      }
      return null;
    } catch (e) {
      errorMessage = "Unexpected Error: $e";
      return null;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
