import 'package:http/http.dart' as http;
import 'dart:convert';

import 'chat_screen.dart';

class Client {
  Future<ChatMessage?> reply(String apiKey, List<ChatMessage> messages) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $apiKey'};
    final body = json.encode({
      'messages': messages,
      'model': 'gpt-3.5-turbo',
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception('Failed to load response: ${response.statusCode}');
    }

    final data = json.decode(response.body);
    final message = data['choices'].last['message'];
    final replayMessage = ChatMessage.fromJson(message);

    return replayMessage;
  }
}