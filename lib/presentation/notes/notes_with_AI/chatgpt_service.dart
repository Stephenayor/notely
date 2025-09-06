import 'dart:convert';
import 'dart:developer'; // for log()
import 'package:http/http.dart' as http;
import 'package:notely/utils/constants.dart';

class ChatGptService {
  // static const _apiKey =
  //     "YOUR_API_KEY"; // replace with env/secure storage later

  static Future<String> generateNote(String topic) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");
    final body = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Give me a short helpful note on $topic"},
      ],
    };

    log("Calling: $url");
    log("Body: ${jsonEncode(body)}");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer ${Constants.apiKey}",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    log("Status: ${response.statusCode}");
    log("Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception(
        "Failed with status ${response.statusCode}: ${response.body}",
      );
    }
  }

  static Future<String> rephrase(String text) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");
    final body = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Rephrase this note: $text"},
      ],
    };

    log("Calling: $url");
    log("Body: ${jsonEncode(body)}");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer ${Constants.apiKey}",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    log("Status: ${response.statusCode}");
    log("Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception(
        "Failed with status ${response.statusCode}: ${response.body}",
      );
    }
  }
}
