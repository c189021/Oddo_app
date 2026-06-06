import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../data/dummy/diary_flow_dummy.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../../../widgets/mascot_image.dart';
import '../../../../widgets/video_call_widgets.dart';

/// Screen 44 — Step 4. 영상통화 상담. Video-call style counseling. 상담 종료 →
/// 리포트 생성.
class DiaryStep4CounselCallScreen extends StatelessWidget {
  const DiaryStep4CounselCallScreen({super.key});

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
                  icon: const Icon(Icons.close_rounded,
                      color: AppColors.callTextPrimary),
                  onPressed: () {
                    if (context.canPop()) context.pop();
                  },
                ),
                const Expanded(
                  child: Text('Step 4. 상담하기',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.callTextPrimary)),
                ),
                IconButton(
                  icon: const Icon(Icons.help_outline_rounded,
                      color: AppColors.callTextPrimary),
                  onPressed: () {},
                ),
              ],
            ),
            const CallStatusRow(
              label: DiaryFlowDummy.counselStatus,
              timer: DiaryFlowDummy.counselTimer,
              dotColor: AppColors.success,
            ),
            Expanded(
              child: Stack(
                children: [
                  // TODO: 상담사처럼 차분하고 공감하는 큰 포즈로 교체 예정
                  const Center(
                      child: MascotImage(
                          pose: MascotPose.counselor, size: 200, onDark: true)),
                  const Positioned(
                    top: 8,
                    right: AppSpacing.screenH,
                    child: CallChip(
                        icon: Icons.show_chart_rounded, label: '감정 변화 측정 중'),
                  ),
                  const Positioned(
                      left: AppSpacing.screenH,
                      bottom: 96,
                      child: CallUserPreview(width: 80, height: 106)),
                  const Positioned(
                    left: AppSpacing.screenH,
                    right: AppSpacing.screenH,
                    bottom: 84,
                    child: _OddoBubble(),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 12,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CallControlButton(
                              icon: Icons.mic_rounded, label: '마이크'),
                          const SizedBox(width: 20),
                          CallControlButton(
                            icon: Icons.call_end_rounded,
                            label: '상담 종료',
                            danger: true,
                            onTap: () => context
                                .pushReplacementNamed(AppRoute.reportGenerating),
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

class _OddoBubble extends StatelessWidget {
  const _OddoBubble();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(DiaryFlowDummy.counselBubble,
          style: AppTypography.bodySecondary
              .copyWith(color: AppColors.textPrimary)),
    );
  }
}
