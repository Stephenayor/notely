import 'package:toast/toast.dart';

class Constants {
  static void showToast(String message, int toastLength) {
    Toast.show(message, duration: toastLength, gravity: Toast.bottom);
  }

  static const String savedEmail = "SavedEmail";
  static const NOTE_CHANNEL_ID = 'note_channel_id';
  static const apiKey =
      "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";
}
