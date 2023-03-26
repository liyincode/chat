import 'dart:convert';
import 'package:flutter/material.dart';


import 'client.dart';
import 'home.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;

  const ChatScreen({super.key, required this.chat});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> _messages = [];
  final _controller = TextEditingController();
  late final Client client;

  void _send(String text) async {
    final message = ChatMessage(role: 'user', content: text);

    setState(() {
      _messages.add(message);
    });

    await _replay();
  }

  Future<void> _replay() async {
    try {
      final replayMessage = await client.reply('', _messages);
      if (replayMessage != null) {
        setState(() {
          _messages.add(replayMessage);
        });
      } else {
        _showErrorDialog('Failed to get response from OpenAI API.');
      }
    } catch (e) {
      _showErrorDialog('Error: $e');
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    client = Client();

    if (widget.chat.messages.isNotEmpty) {
      _messages = widget.chat.messages;
      // _replay();
    }
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
  final void Function(String) onSendPressed;

  final TextEditingController controller;

  const ChatInput(
      {super.key, required this.onSendPressed, required this.controller});

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
                widget.onSendPressed(text);
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
