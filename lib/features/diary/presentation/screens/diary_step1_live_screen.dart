import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../../../widgets/mascot_image.dart';
import '../../../../widgets/video_call_widgets.dart';

/// Screen 37 — Step 1. 실시간 말하기. Video-call style live recording. End call
/// → Step 1 처리 중.
class DiaryStep1LiveScreen extends StatelessWidget {
  const DiaryStep1LiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.callBackground,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 20, color: AppColors.callTextPrimary),
                  onPressed: () {
                    if (context.canPop()) context.pop();
                  },
                ),
                Expanded(
                  child: Text('Step 1. 말하기',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700)),
                ),
                IconButton(
                  icon: const Icon(Icons.help_outline_rounded,
                      size: 20, color: AppColors.callTextPrimary),
                  onPressed: () {},
                ),
              ],
            ),
            const CallStatusRow(label: 'AI와 실시간 대화 중', timer: '00:02:48'),
            Expanded(
              child: Stack(
                children: [
                  // TODO: 큰 상담 상대처럼 손 흔드는 포즈로 교체 예정
                  const Center(
                      child: MascotImage(
                          pose: MascotPose.waving, size: 200, onDark: true)),
                  const Positioned(
                    top: 8,
                    left: AppSpacing.screenH,
                    child: CallChip(
                        icon: Icons.graphic_eq_rounded, label: '음성 인식 중'),
                  ),
                  const Positioned(
                      top: 8, right: AppSpacing.screenH, child: _AnalysisChip()),
                  const Positioned(
                      left: AppSpacing.screenH,
                      bottom: 16,
                      child: CallUserPreview()),
                  Positioned(
                    right: 0,
                    left: 0,
                    bottom: 16,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CallControlButton(
                              icon: Icons.mic_rounded, label: '마이크'),
                          const SizedBox(width: 20),
                          CallControlButton(
                            icon: Icons.call_end_rounded,
                            label: '통화 종료',
                            danger: true,
                            onTap: () => context
                                .pushReplacementNamed(AppRoute.diaryStep1Processing),
                          ),
                          const SizedBox(width: 20),
                          const CallControlButton(
                              icon: Icons.volume_up_rounded, label: '스피커'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Step 1-specific "real-time emotion analysis" chip with a mini waveform.
class _AnalysisChip extends StatelessWidget {
  const _AnalysisChip();

  static const List<double> _bars = [6, 12, 8, 16, 10, 14, 7];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.callSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('실시간 감정 분석',
              style: AppTypography.caption
                  .copyWith(color: AppColors.callTextSecondary)),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (final h in _bars)
                Container(
                  width: 3,
                  height: h,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
