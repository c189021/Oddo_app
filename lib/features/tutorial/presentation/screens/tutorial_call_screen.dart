import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../../../widgets/mascot_image.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/video_call_widgets.dart';

/// Screen 11 — 튜토리얼 통화 연습 (1/5). Video-call style practice → 2/5.
class TutorialCallScreen extends StatelessWidget {
  const TutorialCallScreen({super.key});

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
                  child: Text('튜토리얼 1/5',
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
            const CallStatusRow(label: 'AI와 실시간 대화 중', timer: '00:02:48'),
            Gap.h8,
            Expanded(
              child: Stack(
                children: [
                  // TODO: 상담 상대처럼 크게 손 흔드는 포즈로 교체 예정
                  const Center(
                      child: MascotImage(
                          pose: MascotPose.waving, size: 190, onDark: true)),
                  const Positioned(
                    top: 8,
                    left: AppSpacing.screenH,
                    child: CallChip(
                        icon: Icons.graphic_eq_rounded, label: '음성 인식 중'),
                  ),
                  Positioned(
                    top: 4,
                    right: AppSpacing.screenH,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: AppColors.callSurface, shape: BoxShape.circle),
                      child: const Icon(Icons.cameraswitch_rounded,
                          size: 18, color: AppColors.callTextSecondary),
                    ),
                  ),
                  // 우상단(카메라 전환 버튼 아래) — 하단 버튼과 겹치지 않게.
                  const Positioned(
                      top: 56,
                      right: AppSpacing.screenH,
                      child: CallUserPreview()),
                  const Positioned(
                    right: 0,
                    left: 0,
                    bottom: 12,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CallControlButton(icon: Icons.mic_rounded),
                          SizedBox(width: 20),
                          CallControlButton(
                              icon: Icons.call_end_rounded, danger: true),
                          SizedBox(width: 20),
                          CallControlButton(icon: Icons.volume_up_rounded),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenH,
                  AppSpacing.xs, AppSpacing.screenH, AppSpacing.xs),
              child: Column(
                children: [
                  const _GuidePanel(),
                  Gap.h12,
                  PrimaryButton(
                    label: '대화 시작하기',
                    trailingIcon: Icons.chevron_right_rounded,
                    onPressed: () =>
                        context.pushNamed(AppRoute.tutorialSelfIntro),
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

class _GuidePanel extends StatelessWidget {
  const _GuidePanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.videocam_rounded, size: 20, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('지금부터 간단한 대화를 통해 당신의 평소 상태를 파악할 거예요.',
                    style: AppTypography.bodySecondary
                        .copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                const Text('약 5~7분 정도 소요돼요. 편하게 이야기해주세요.',
                    style: AppTypography.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
