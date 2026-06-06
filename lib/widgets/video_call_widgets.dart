import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

/// Shared chrome for the dark video-call screens (tutorial call practice,
/// baseline measuring, Step 1 live speaking, Step 4 counseling). Extracted so
/// the four screens share one implementation.

/// Live status row: a colored dot + label + timer, centered.
class CallStatusRow extends StatelessWidget {
  const CallStatusRow({
    super.key,
    required this.label,
    required this.timer,
    this.dotColor = AppColors.error,
  });

  final String label;
  final String timer;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: AppTypography.caption
                .copyWith(color: AppColors.callTextSecondary)),
        const SizedBox(width: 10),
        Text(timer,
            style: AppTypography.caption
                .copyWith(color: AppColors.callTextPrimary)),
      ],
    );
  }
}

/// Small pill chip on the dark call surface (e.g. "음성 인식 중").
class CallChip extends StatelessWidget {
  const CallChip({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.callSurface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.primary),
          const SizedBox(width: 5),
          Text(label,
              style: AppTypography.caption
                  .copyWith(color: AppColors.callTextPrimary)),
        ],
      ),
    );
  }
}

/// Small user-camera preview placeholder (bottom-left of the call view).
class CallUserPreview extends StatelessWidget {
  const CallUserPreview({super.key, this.width = 84, this.height = 112});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.callSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: const Icon(Icons.person_rounded,
          size: 34, color: AppColors.callTextSecondary),
    );
  }
}

/// A round call-control button (mic / end / speaker …) with an optional label.
class CallControlButton extends StatelessWidget {
  const CallControlButton({
    super.key,
    required this.icon,
    this.label,
    this.danger = false,
    this.onTap,
  });

  final IconData icon;
  final String? label;
  final bool danger;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final button = GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: danger ? AppColors.error : AppColors.callSurface,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 24, color: AppColors.callTextPrimary),
      ),
    );

    if (label == null) return button;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        button,
        const SizedBox(height: 6),
        Text(label!,
            style: AppTypography.caption
                .copyWith(color: AppColors.callTextSecondary)),
      ],
    );
  }
}
