import 'package:flutter/material.dart';

import '../core/constants/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Renders the mascot (탄카츄) in a given [pose].
///
/// For now every pose shows one unified placeholder image
/// ([AppAssets.tankachuPlaceholder]); [pose] still carries the intended
/// expression so screens document it and per-pose art can be swapped in later
/// (switch to [AppAssets.mascot]`(pose)`). If even the placeholder is missing,
/// a styled fallback box is drawn.
class MascotImage extends StatelessWidget {
  const MascotImage({
    super.key,
    required this.pose,
    this.size = 120,
    this.onDark = false,
  });

  final MascotPose pose;
  final double size;

  /// Use a lighter placeholder when shown on a dark (video-call) background.
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.tankachuPlaceholder,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: onDark ? AppColors.callSurface : AppColors.primarySoft,
        borderRadius: BorderRadius.circular(size * 0.26),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.pets_rounded,
            size: size * 0.34,
            color: onDark ? AppColors.callTextSecondary : AppColors.primary,
          ),
          SizedBox(height: size * 0.05),
          Text(
            pose.name,
            style: AppTypography.caption.copyWith(
              color: onDark ? AppColors.callTextSecondary : AppColors.primary,
              fontSize: size * 0.09,
            ),
          ),
        ],
      ),
    );
  }
}
