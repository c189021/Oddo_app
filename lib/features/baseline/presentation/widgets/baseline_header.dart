import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../../../widgets/step_progress_bar.dart';

/// Top bar for the baseline flow: leading (back/close) + centered title + help
/// icon, with the labeled step-progress bar below. Light + dark variants.
class BaselineHeader extends StatelessWidget {
  const BaselineHeader({
    super.key,
    required this.title,
    required this.stepLabels,
    required this.activeStep,
    this.dark = false,
    this.leadingIcon = Icons.arrow_back_ios_new_rounded,
    this.onLeading,
  });

  final String title;
  final List<String> stepLabels;
  final int activeStep;
  final bool dark;
  final IconData leadingIcon;
  final VoidCallback? onLeading;

  @override
  Widget build(BuildContext context) {
    final fg = dark ? AppColors.callTextPrimary : AppColors.textStrong;
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(leadingIcon, size: 20, color: fg),
              onPressed: onLeading ??
                  () {
                    if (context.canPop()) context.pop();
                  },
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.bodyLarge
                    .copyWith(color: fg, fontWeight: FontWeight.w600),
              ),
            ),
            IconButton(
              icon: Icon(Icons.help_outline_rounded, size: 20, color: fg),
              onPressed: () {}, // TODO: open help later.
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: StepProgressBar(
            labels: stepLabels,
            currentIndex: activeStep,
            onDark: dark,
          ),
        ),
      ],
    );
  }
}
