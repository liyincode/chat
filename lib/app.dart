import 'package:flutter/material.dart';

import 'chat_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Row(
        children: [
          NavigationDrawer(
            children: [
              ...[1, 2, 3].map((e) => NavigationDrawerDestination(
                    icon: const Icon(Icons.question_answer_outlined),
                    label: Text(e.toString()),
                    selectedIcon: const Icon(Icons.question_answer),
                  )),
            ],
          ),
          const Expanded(
            child: ChatScreen(),
          ),
        ],
      ),
    );
  }
}
