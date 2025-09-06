import 'dart:async';

class ChatGptServiceMock {
  static Future<String> generateNote(String topic) async {
    await Future.delayed(const Duration(seconds: 1)); // fake network delay
    return "Here’s a quick helpful note on $topic:\n\n"
        "- Stay focused on the main idea.\n"
        "- Break things down into smaller points.\n"
        "- Keep it simple and actionable.";
  }

  static Future<String> rephrase(String text) async {
    await Future.delayed(const Duration(seconds: 1)); // fake delay
    return "Rephrased version:\n\n$text (expressed in simpler terms)";
  }
}
