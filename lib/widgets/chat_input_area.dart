import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../theme/app_colors.dart';

class ChatInputArea extends StatefulWidget {
  final Function(String) onSubmitted;
  final Function(File) onAudioSubmitted;
  final bool isGenerating;
  final VoidCallback onStopGenerating;

  const ChatInputArea({
    super.key, 
    required this.onSubmitted,
    required this.onAudioSubmitted,
    this.isGenerating = false,
    required this.onStopGenerating,
  });

  @override
  State<ChatInputArea> createState() => _ChatInputAreaState();
}

class _ChatInputAreaState extends State<ChatInputArea> {
  final TextEditingController _controller = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  
  bool _isComposing = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTextChanged);
  }

  void _handleTextChanged() {
    setState(() {
      _isComposing = _controller.text.isNotEmpty;
    });
  }

  void _startListening() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        final path = '${directory.path}/audio_record_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        const config = RecordConfig();
        
        await _audioRecorder.start(config, path: path);
        
        setState(() {
          _isListening = true;
        });
      }
    } catch (e) {
      print('Recording start failed: $e');
    }
  }

  void _stopListening() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isListening = false;
      });
      
      if (path != null) {
        widget.onAudioSubmitted(File(path));
      }
    } catch (e) {
      print('Recording stop failed: $e');
    }
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
                onPressed: _isListening ? _stopListening : _startListening,
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
