import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import '../theme/app_colors.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF4F4F2),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => _handleSubmitted(),
            maxLines: 5,
            minLines: 1,
            cursorColor: AppColors.bleuCiel,
            decoration: InputDecoration(
              hintText: 'Discutez avec NOVA',
              hintStyle: TextStyle(
                color: isDark ? Colors.white54 : Colors.black38,
                fontSize: 16.0,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add, color: AppColors.bleuMarine),
                iconSize: 24.0,
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: _isListening ? Colors.red : AppColors.bleuMarine,
                ),
                iconSize: 24.0,
                onPressed: _speechToText.isNotListening ? _startListening : _stopListening,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              if (widget.isGenerating || _isComposing)
                GestureDetector(
                  onTap: widget.isGenerating ? widget.onStopGenerating : _handleSubmitted,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.vertTeal,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.isGenerating ? Icons.stop : Icons.arrow_upward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.vertTeal,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.graphic_eq,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
