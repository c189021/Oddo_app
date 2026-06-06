import 'package:flutter/material.dart';

import '../../../../widgets/placeholder_screen.dart';

/// Auxiliary — 알림 목록.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: '알림',
      description: '기록 리마인드 · 리포트 완료 알림',
    );
  }
}
