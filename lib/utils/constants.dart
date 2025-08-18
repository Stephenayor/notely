import 'package:toast/toast.dart';

class Constants {
  static void showToast(String message, int toastLength) {
    Toast.show(message, duration: toastLength, gravity: Toast.bottom);
  }

  static const String savedEmail = "SavedEmail";
}
