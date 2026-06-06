import 'package:flutter/material.dart';

import '../../../../widgets/placeholder_screen.dart';

/// Auxiliary — 마이페이지.
class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: '마이페이지',
      description: '프로필 · 계정 · 기록 통계',
    );
  }
}
