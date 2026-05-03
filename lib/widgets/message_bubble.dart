import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MessageBubble extends StatelessWidget {
  final String? text;
  final Widget? child;
  final bool isUser;

  const MessageBubble({
    super.key,
    this.text,
    this.child,
    required this.isUser,
  }) : assert(text != null || child != null);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        padding: isUser
            ? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0)
            : const EdgeInsets.only(right: 16.0, top: 4.0, bottom: 4.0),
        decoration: isUser
            ? BoxDecoration(
                color: AppColors.vertTeal, // Teal for user bubble
                borderRadius: BorderRadius.circular(20),
              )
            : null, // No background for bot
        child: child ??
            Text(
              text!,
              style: TextStyle(
                fontSize: 16.0,
                color: isUser ? Colors.white : Colors.black87,
                height: 1.4,
              ),
            ),
      ),
    );
  }
}
