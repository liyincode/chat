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

  void _onNewChat() {
    setState(() {
      _chatList.add(Chat(
        title: '新的聊天',
        messages: [ChatMessage(role: 'system', content: '开始新的聊天')],
      ));
      _selectedChatIndex = _chatList.length - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          buildChatList(),
          buildChatScreen(),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: FloatingActionButton.extended(
          extendedPadding: const EdgeInsets.symmetric(horizontal: 86),
          onPressed: _onNewChat,
          label: const Text('New Chat'),
          icon: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }

  NavigationDrawer buildChatList() {
    return NavigationDrawer(
      onDestinationSelected: _onDestinationSelected,
      selectedIndex: _selectedChatIndex,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            'Chat',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 30,
            ),
          ),
        ),
        const SizedBox(height: 110),
        for (final chatTitle in _chatList)
          NavigationDrawerDestination(
            icon: const Icon(Icons.question_answer_outlined),
            label: Text(chatTitle.title),
            selectedIcon: const Icon(Icons.question_answer),
          ),
        const SizedBox(height: 20),
        Divider(
          color: Colors.grey[300],
          thickness: 1,
          height: 1,
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
