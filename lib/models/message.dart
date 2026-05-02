import 'package:flutter/material.dart';

class Message {
  final String? text;
  final Widget? richChild;
  final bool isUser;

  Message({
    this.text,
    this.richChild,
    required this.isUser,
  }) : assert(text != null || richChild != null);
}
