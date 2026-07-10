import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../features/auth/application/auth_controller.dart';
import '../../../../widgets/placeholder_screen.dart';

/// Auxiliary — 설정 홈. Entry to my-page / chatbot settings / logout.
class SettingsHomeScreen extends ConsumerWidget {
  const SettingsHomeScreen({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(authControllerProvider.notifier).logout();
    if (context.mounted) context.goNamed(AppRoute.login);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlaceholderScreen(
      title: '설정',
      actions: [
        const PlaceholderAction('마이페이지', routeName: AppRoute.myPage),
        const PlaceholderAction('챗봇 설정',
            routeName: AppRoute.chatbotSettings, primary: false),
        PlaceholderAction('로그아웃',
            primary: false, onTap: () => _logout(context, ref)),
      ],
    );
  }
}
