import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../data/dummy/baseline_dummy.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../../../widgets/app_background.dart';
import '../../../../widgets/mascot_image.dart';
import '../../../../widgets/oddo_card.dart';

/// Screen 20 — Baseline 분석 중. Loading state; auto-advances to the
/// completion screen after a dummy delay.
class BaselineAnalyzingScreen extends StatefulWidget {
  const BaselineAnalyzingScreen({super.key});

  @override
  State<BaselineAnalyzingScreen> createState() =>
      _BaselineAnalyzingScreenState();
}

class _BaselineAnalyzingScreenState extends State<BaselineAnalyzingScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2600), () {
      if (mounted) context.pushReplacementNamed(AppRoute.baselineDone);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
              child: Column(
                children: [
                  // TODO: 노트북을 보며 분석하는 포즈로 교체 예정 (character_sheet 15.노트북)
                  const MascotImage(pose: MascotPose.thinking, size: 150),
                  Gap.h20,
                  const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                        strokeWidth: 3, color: AppColors.primary),
                  ),
                  Gap.h20,
                  const Text('첫 감정 기준을 정리하고 있어요',
                      textAlign: TextAlign.center, style: AppTypography.title),
                  Gap.h8,
                  const Text('잠시만 기다려주세요.',
                      style: AppTypography.bodySecondary),
                  Gap.h24,
                  OddoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final item in BaselineDummy.analysisItems)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_rounded,
                                    size: 18, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text(item, style: AppTypography.body),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
