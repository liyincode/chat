import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [
    ChatMessage(sender: 'Bot', text: 'Hello, how can I help you?'),
    ChatMessage(
        sender: 'User', text: 'Can you recommend a good restaurant nearby?'),
    ChatMessage(sender: 'Bot', text: 'Sure, what type of food do you prefer?'),
    ChatMessage(sender: 'User', text: 'I like Italian food.'),
    ChatMessage(
        sender: 'Bot',
        text:
            'There is a great Italian restaurant called "La Piazza" nearby. Would you like me to make a reservation?'),
    ChatMessage(sender: 'User', text: 'Yes, please.'),
    ChatMessage(
        sender: 'Bot', text: 'What time and date would you like to book?'),
    ChatMessage(sender: 'User', text: 'How about tomorrow at 7pm?'),
    ChatMessage(
        sender: 'Bot',
        text:
            'Great, I have made a reservation for you at La Piazza tomorrow at 7pm. Enjoy your meal!'),
  ];
  final _isUser = true;
  final _controller = TextEditingController();

  void _addMessage(String text, {bool isUser = true}) {
    final message = ChatMessage(sender: _isUser ? 'User' : 'Bot', text: text);
    setState(() {
      _messages.add(message);
    });
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
          onSendPressed: _addMessage,
          controller: _controller,
        ),
      ],
    );
  }
}

class ChatMessageListItem extends StatelessWidget {
  final ChatMessage message;

  ChatMessageListItem({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    return ListTile(
      title: Text(
        textAlign: isMe ? TextAlign.right : TextAlign.left,
        message.text,
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

  ChatInput({required this.onSendPressed, required this.controller});

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                labelText: 'Type a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
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
  final String sender;
  final String text;

  ChatMessage({required this.sender, required this.text});

  bool get isMe => sender == 'User';
}
