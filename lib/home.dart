import 'package:flutter/material.dart';

import 'chat_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedChatIndex = 0;

  final List<Chat> _chatList = [
    Chat(
      title: '随便聊聊',
      messages: [ChatMessage(role: 'system', content: '随便聊聊')],
    ),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedChatIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Row(
        children: [
          buildChatList(),
          buildChatScreen(),
        ],
      ),
    );
  }

  NavigationDrawer buildChatList() {
    return NavigationDrawer(
      onDestinationSelected: _onDestinationSelected,
      selectedIndex: _selectedChatIndex,
      children: [
        for (final chatTitle in _chatList)
          NavigationDrawerDestination(
            icon: const Icon(Icons.question_answer_outlined),
            label: Text(chatTitle.title),
            selectedIcon: const Icon(Icons.question_answer),
          ),
      ],
    );
  }

  Expanded buildChatScreen() {
    return Expanded(
      child: ChatScreen(
        chat: _chatList[_selectedChatIndex],
      ),
    );
  }
}

class Chat {
  final String title;
  final List<ChatMessage> messages;

  Chat({required this.title, required this.messages});
}
