import 'package:flutter/material.dart';
import 'models/message.dart';
import 'widgets/chat_input_area.dart';
import 'widgets/message_bubble.dart';

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

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black, size: 28),
          onPressed: () {},
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'NOVA HEALTH',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
            ),
            SizedBox(width: 4.0),
            Icon(Icons.chevron_right, color: Colors.black54, size: 20.0),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_square, color: Colors.black, size: 24),
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
