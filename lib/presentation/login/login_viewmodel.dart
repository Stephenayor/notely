import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notely/domain/user_repository.dart';
import 'package:notely/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  String? errorMessage;
  String? savedEmail;
  final UserRepository _userRepository;

  LoginViewModel(this._userRepository) {
    _loadSavedEmail();
  }

  Future<void> _loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    savedEmail = prefs.getString(Constants.savedEmail);
    notifyListeners();
  }

  Future<void> _saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.savedEmail, email);
    savedEmail = email;
    notifyListeners();
  }

  Future<User?> loginWithEmail(String email, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final credential = await _userRepository.signInEmailPassword(
        email,
        password,
      );

      await _saveEmail(email);
      return credential.user;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      if (userCredential.user?.email != null) {
        await _saveEmail(userCredential.user!.email!);
      }

      return userCredential.user;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(Constants.savedEmail);
    savedEmail = null;
    notifyListeners();
  }

  void reset() {
    errorMessage = null;
    isLoading = false;
    notifyListeners();
  }
}
