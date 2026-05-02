import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatInputArea extends StatefulWidget {
  final Function(String) onSubmitted;
  final bool isGenerating;
  final VoidCallback onStopGenerating;

  const ChatInputArea({
    super.key, 
    required this.onSubmitted,
    this.isGenerating = false,
    required this.onStopGenerating,
  });

  @override
  State<ChatInputArea> createState() => _ChatInputAreaState();
}

class _ChatInputAreaState extends State<ChatInputArea> {
  final TextEditingController _controller = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  
  bool _isComposing = false;
  bool _isListening = false;
  bool _isSpeechInitialized = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _controller.addListener(_handleTextChanged);
  }

  void _handleTextChanged() {
    setState(() {
      _isComposing = _controller.text.isNotEmpty;
    });
  }

  Future<void> _initSpeech() async {
    try {
      _isSpeechInitialized = await _speechToText.initialize();
      setState(() {});
    } catch (e) {
      print('Speech initialization failed: $e');
    }
  }

  void _startListening() async {
    setState(() {
      _isListening = true;
    });

    if (_isSpeechInitialized) {
      // True native speech recognition
      await _speechToText.listen(onResult: (result) {
        setState(() {
          _controller.text = result.recognizedWords;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        });
      });
    } else {
      // Simulation for environments like Windows where native speech might fail
      Future.delayed(const Duration(seconds: 2), () {
        if (_isListening && mounted) {
          setState(() {
            String simulatedText = "Ceci est une simulation vocale. Bonjour NOVA HEALTH !";
            _controller.text = simulatedText;
            _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: simulatedText.length),
            );
          });
          _stopListening();
        }
      });
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _handleSubmitted() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onSubmitted(_controller.text);
      _controller.clear();
      _stopListening();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0, bottom: 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _handleSubmitted(),
              decoration: const InputDecoration(
                hintText: 'Ask anything',
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8.0),
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      iconSize: 28.0,
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 24.0),
                    IconButton(
                      icon: const Icon(Icons.tune),
                      iconSize: 28.0,
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (widget.isGenerating) ...[
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(
                              Icons.stop,
                              color: Colors.white,
                              size: 18.0,
                            ),
                            padding: EdgeInsets.zero,
                            onPressed: widget.onStopGenerating,
                          ),
                        ),
                      ),
                    ] else if (_isComposing) ...[
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 18.0,
                            ),
                            padding: EdgeInsets.zero,
                            onPressed: _handleSubmitted,
                          ),
                        ),
                      ),
                    ] else ...[
                      IconButton(
                        icon: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          color: _isListening ? Colors.red : Colors.black87,
                        ),
                        iconSize: 28.0,
                        onPressed: _speechToText.isNotListening ? _startListening : _stopListening,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
