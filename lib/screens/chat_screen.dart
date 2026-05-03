import 'package:flutter/material.dart';
import '../models/message.dart';
import '../theme/app_colors.dart';
import '../widgets/app_drawer.dart';
import '../widgets/chat_input_area.dart';
import '../widgets/message_bubble.dart';
import 'auth_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [
    Message(
      text: "Bonjour ! Je suis NOVA HEALTH. Comment puis-je vous aider aujourd'hui ?",
      isUser: false,
    ),
  ];

  final ScrollController _scrollController = ScrollController();

  bool _isGenerating = false;
  int _messageCount = 0;
  bool _isLoggedIn = false;

  void _showAuthScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
    
    if (result == true) {
      setState(() {
        _isLoggedIn = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connexion réussie ! Vous pouvez continuer à discuter.')),
      );
    }
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    if (!_isLoggedIn && _messageCount >= 3) {
      _showAuthScreen();
      return;
    }

    setState(() {
      _messageCount++;
      _messages.add(Message(text: text, isUser: true));
      _isGenerating = true;
    });

    _scrollToBottom();

    // Simulate bot response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _isGenerating) {
        setState(() {
          _messages.add(Message(
            text: "Je suis un assistant virtuel NOVA HEALTH. J'ai bien reçu votre message : \"$text\"",
            isUser: false,
          ));
          _isGenerating = false;
        });
        _scrollToBottom();
      }
    });
  }

  void _stopGenerating() {
    setState(() {
      _isGenerating = false;
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(isLoggedIn: _isLoggedIn),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu, 
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.bleuMarine, 
              size: 28,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_hospital, color: AppColors.bleuCiel, size: 20.0),
            const SizedBox(width: 8.0),
            Text(
              'NOVA HEALTH',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.bleuMarine,
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          if (_isLoggedIn)
            IconButton(
              icon: const Icon(Icons.edit_square, color: AppColors.bleuCiel, size: 24),
              onPressed: () {
                setState(() {
                  _messages.clear();
                  _messages.add(Message(
                    text: "Bonjour ! Je suis NOVA HEALTH. Comment puis-je vous aider aujourd'hui ?",
                    isUser: false,
                  ));
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 16.0, bottom: 60.0),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    return MessageBubble(
                      isUser: msg.isUser,
                      text: msg.text,
                      child: msg.richChild,
                    );
                  },
                ),
              ],
            ),
          ),
          ChatInputArea(
            onSubmitted: _handleSubmitted,
            isGenerating: _isGenerating,
            onStopGenerating: _stopGenerating,
          ),
        ],
      ),
    );
  }
}
