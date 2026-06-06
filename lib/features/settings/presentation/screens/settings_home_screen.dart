import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../widgets/placeholder_screen.dart';

/// Auxiliary — 설정 홈. Entry to my-page / chatbot settings / logout.
class SettingsHomeScreen extends StatelessWidget {
  const SettingsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: '설정',
      actions: [
        PlaceholderAction('마이페이지', routeName: AppRoute.myPage),
        PlaceholderAction('챗봇 설정',
            routeName: AppRoute.chatbotSettings, primary: false),
        PlaceholderAction('로그아웃',
            routeName: AppRoute.login, mode: NavMode.go, primary: false),
      ],
    );
  }
}
