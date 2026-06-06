import 'package:flutter/material.dart';

import '../../../../widgets/placeholder_screen.dart';

/// Auxiliary — 챗봇 설정. Adjust the chatbot persona after onboarding.
class ChatbotSettingsScreen extends StatelessWidget {
  const ChatbotSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: '챗봇 설정',
      description: '이름 · 말투 · 성격 다시 설정하기',
    );
  }
}
