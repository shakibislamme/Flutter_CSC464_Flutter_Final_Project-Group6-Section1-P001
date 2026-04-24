import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _apiKey = "for safety";

  Future<String> getAIResponse(String message, String language) async {
    final url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=$_apiKey";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text":
                      "You are a professional $language language tutor. Reply ONLY in $language. User message: $message",
                },
              ],
            },
          ],
        }),
      );

      print("API Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["candidates"][0]["content"]["parts"][0]["text"];
      } else {
        print("API Error Response: ${response.body}");

        return "Gemini Error: ${response.statusCode}. Check Console.";
      }
    } catch (e) {
      return "App Error: $e";
    }
  }
}
