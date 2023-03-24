import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final _controller = TextEditingController();

  Future<void> _reply() async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer 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',
        },
        body: json.encode({
          'messages': _messages,
          'model': 'gpt-3.5-turbo',
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final message = jsonResponse['choices'].last['message'];
        final chatMessage = ChatMessage.fromJson(message);
        setState(() {
          _messages.add(chatMessage);
        });
      } else {
        throw Exception('Failed to load response');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _send(String text, {bool isUser = true}) async {
    final message = ChatMessage(role: 'user', content: text);

    setState(() {
      _messages.add(message);
    });

    await _reply();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (BuildContext context, int index) {
              final message = _messages[index];
              return ChatMessageListItem(message: message);
            },
          ),
        ),
        ChatInput(
          onSendPressed: _send,
          controller: _controller,
        ),
      ],
    );
  }
}

class ChatMessageListItem extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageListItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    return ListTile(
      title: Text(
        textAlign: isMe ? TextAlign.right : TextAlign.left,
        message.content,
        style: TextStyle(
          color: isMe ? Colors.blue : Colors.grey[600],
        ),
      ),
      leading: isMe
          ? null
          : const Icon(
              Icons.android,
              color: Colors.green,
            ),
      trailing: isMe
          ? const Icon(
              Icons.account_circle,
              color: Colors.purple,
            )
          : null,
    );
  }
}

class ChatInput extends StatefulWidget {
  final void Function(String, {bool isUser}) onSendPressed;

  final TextEditingController controller;

  const ChatInput({super.key, required this.onSendPressed, required this.controller});

  @override
  ChatInputState createState() => ChatInputState();
}

class ChatInputState extends State<ChatInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: const InputDecoration(
                labelText: 'Type a message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final text = widget.controller.text;
              if (text.isNotEmpty) {
                widget.onSendPressed(text, isUser: true);
                widget.controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String role;
  final String content;

  ChatMessage({required this.role, required this.content});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'],
      content: utf8.decode(json['content'].runes.toList()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }

  bool get isMe => role == 'user';
}
