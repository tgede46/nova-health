import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';
import 'theme/app_colors.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const NovaHealthChatApp());
}

class NovaHealthChatApp extends StatelessWidget {
  const NovaHealthChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'NOVA HEALTH',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.bleuMarine, brightness: Brightness.light),
            useMaterial3: true,
            fontFamily: 'Inter',
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.bleuMarine,
              brightness: Brightness.dark,
              surface: const Color(0xFF1E1E1E),
            ),
            useMaterial3: true,
            fontFamily: 'Inter',
            scaffoldBackgroundColor: const Color(0xFF121212),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF121212),
              surfaceTintColor: Colors.transparent,
              elevation: 0,
            ),
          ),
          home: const ChatScreen(),
        );
      },
    );
  }
}
