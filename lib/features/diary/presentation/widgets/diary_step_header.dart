import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../../../widgets/step_indicator.dart';

/// Shared header for the 4-step diary-write flow: a top row (back/close +
/// title + help) and the [StepIndicator] showing the active step.
class DiaryStepHeader extends StatelessWidget {
  const DiaryStepHeader({
    super.key,
    this.title = '일기 작성하기',
    required this.currentStep,
    this.showHelp = true,
    this.leadingClose = false,
  });

  final String title;
  final int currentStep; // 0=말하기 .. 3=상담하기
  final bool showHelp;
  final bool leadingClose;

  static const List<String> steps = ['말하기', '확인하기', '영상 제작', '상담하기'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(
                  leadingClose
                      ? Icons.close_rounded
                      : Icons.arrow_back_ios_new_rounded,
                  size: 20),
              onPressed: () {
                if (context.canPop()) context.pop();
              },
            ),
            Expanded(
              child: Text(title,
                  textAlign: TextAlign.center, style: AppTypography.subtitle),
            ),
            if (showHelp)
              IconButton(
                icon: const Icon(Icons.help_outline_rounded, size: 20),
                onPressed: () {},
              )
            else
              const SizedBox(width: 48),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenH, vertical: AppSpacing.xs),
          child: StepIndicator(steps: steps, currentIndex: currentStep),
        ),
      ],
    );
  }
}
