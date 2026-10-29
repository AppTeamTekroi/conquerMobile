import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatBotService {
  final String apiKey = 'your-openai-api-key';
  final String apiUrl = 'https://api.openai.com/v1/assistants';

  Future<String> getChatBotResponse(String userInput, String threadId) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = jsonEncode({
      'assistant_id': 'your-assistant-id',
      'thread_id': threadId,
      'messages': [
        {'role': 'user', 'content': userInput}
      ]
    });

    try {
      final response = await http.post(Uri.parse('$apiUrl/runs'), headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final content = responseData['message']['content'];
        return content ?? 'I am unable to respond right now. Please try again.';
      } else {
        return 'Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Error: Unable to connect to the API. Please check your internet connection.';
    }
  }
}
