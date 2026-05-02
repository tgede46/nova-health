import 'package:flutter/material.dart';
import 'chat_screen.dart';

void main() {
  runApp(const NovaHealthChatApp());
}

class NovaHealthChatApp extends StatelessWidget {
  const NovaHealthChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NOVA HEALTH',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        fontFamily: 'Inter', // Assuming a clean sans-serif like Inter, fallback is default
      ),
      home: const ChatScreen(),
    );
  }
}
