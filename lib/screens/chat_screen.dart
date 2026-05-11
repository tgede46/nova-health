import 'package:flutter/material.dart';
import 'dart:io';
import '../models/message.dart';
import '../models/chat_request.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';
import '../theme/app_colors.dart';
import '../widgets/settings_overlay.dart';
import '../widgets/chat_input_area.dart';
import '../widgets/message_bubble.dart';
import '../widgets/top_notification.dart';
import '../widgets/pharmacy_list.dart';
import '../models/chat_response.dart';
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
  final ApiService _apiService = ApiService();

  bool _isGenerating = false;
  int _messageCount = 0;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    // Precache logo for fast and smooth display
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage('assets/images/logo.png'), context);
      LocationService.checkAndRequestPermissions(context);
    });
  }

  void _showAuthScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
    
    if (result == true) {
      setState(() {
        _isLoggedIn = true;
      });
      TopNotification.show(context, 'Connexion réussie ! Bienvenue.');
    }
  }


  void _handleSubmitted(String text) async {
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

    try {
      // Get location (with default values if fails)
      final position = await LocationService.getCurrentLocation();
      final double lat = position?.latitude ?? 5.3484; // Default to Abidjan if null
      final double lon = position?.longitude ?? -4.0305;

      final request = ChatRequest(
        userMessage: text,
        userLat: lat,
        userLon: lon,
      );

      final response = await _apiService.sendChatMessage(request);

      if (mounted && _isGenerating) {
        _addBotMessage(response);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(Message(
            text: "Désolé, une erreur est survenue : ${e.toString().replaceAll('Exception:', '')}",
            isUser: false,
          ));
          _isGenerating = false;
        });
        _scrollToBottom();
      }
    }
  }

  void _handleAudioSubmitted(File audioFile) async {
    if (!_isLoggedIn && _messageCount >= 3) {
      _showAuthScreen();
      return;
    }

    setState(() {
      _messageCount++;
      _messages.add(Message(text: "Audio envoyé...", isUser: true));
      _isGenerating = true;
    });

    _scrollToBottom();

    try {
      final position = await LocationService.getCurrentLocation();
      final double lat = position?.latitude ?? 5.3484;
      final double lon = position?.longitude ?? -4.0305;

      final response = await _apiService.sendAudioMessage(
        audioFile: audioFile,
        lat: lat,
        lon: lon,
      );

      if (mounted && _isGenerating) {
        _addBotMessage(response);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(Message(
            text: "Désolé, une erreur est survenue lors du traitement de l'audio.",
            isUser: false,
          ));
          _isGenerating = false;
        });
        _scrollToBottom();
      }
    }
  }

  void _addBotMessage(ChatResponse response) {
    Widget? richChild;
    String? resultText;

    if (response.intention == 'PHARMACIE' && response.reponseTexte is List<Pharmacy>) {
      richChild = PharmacyList(
        pharmacies: response.reponseTexte as List<Pharmacy>,
        message: response.message,
      );
    } else {
      if (response.reponseTexte is List) {
        resultText = (response.reponseTexte as List).join("\n");
      } else {
        resultText = response.reponseTexte?.toString() ?? "";
      }

      if (resultText.trim().isEmpty || resultText == "[]") {
        resultText = "Désolé, je n'ai pas pu générer d'orientation précise. Pouvez-vous reformuler ?";
      }
    }

    setState(() {
      _messages.add(Message(
        text: resultText,
        richChild: richChild,
        isUser: false,
      ));
      _isGenerating = false;
    });
    _scrollToBottom();
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

  void _handleLogout() {
    setState(() {
      _isLoggedIn = false;
      _messageCount = 0;
      _messages.clear();
      _messages.add(Message(
        text: "Vous avez été déconnecté. Comment puis-je vous aider ?",
        isUser: false,
      ));
    });
    TopNotification.show(context, 'Déconnexion réussie');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.menu, 
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.bleuMarine, 
            size: 28,
          ),
          onPressed: () {
            SettingsOverlay.show(
              context, 
              _isLoggedIn,
              _handleLogout,
              _showAuthScreen,
            );
          },
        ),
        title: Image.asset(
          'assets/images/logo.png',
          height: 28,
          fit: BoxFit.contain,
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
            onAudioSubmitted: _handleAudioSubmitted,
            isGenerating: _isGenerating,
            onStopGenerating: _stopGenerating,
          ),
        ],
      ),
    );
  }
}
