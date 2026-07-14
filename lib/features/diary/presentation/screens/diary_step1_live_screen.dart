import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/media/audio_recorder_service.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../../../widgets/mascot_image.dart';
import '../../../../widgets/video_call_widgets.dart';
import '../../application/diary_draft_provider.dart';

/// Screen 37 — Step 1. 실시간 말하기. Video-call style live recording — the
/// mic records for the whole call; ending the call stores the file path on
/// the diary draft (Phase 4 uploads it for analysis). → Step 1 처리 중.
class DiaryStep1LiveScreen extends ConsumerStatefulWidget {
  const DiaryStep1LiveScreen({super.key});

  @override
  ConsumerState<DiaryStep1LiveScreen> createState() =>
      _DiaryStep1LiveScreenState();
}

class _DiaryStep1LiveScreenState extends ConsumerState<DiaryStep1LiveScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(audioRecorderProvider).start(
        fileName: 'diary_${DateFormatter.dateKey(DateTime.now())}_step1');
  }

  Future<void> _endCall() async {
    final path = await ref.read(audioRecorderProvider).stop();
    if (path != null) {
      ref.read(diaryDraftProvider.notifier).setRecordingPath(path);
    }
    if (mounted) {
      context.pushReplacementNamed(AppRoute.diaryStep1Processing);
    }
  }

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
                  // 우상단(실시간 감정 분석 칩 아래) — 하단 버튼과 겹치지 않게.
                  const Positioned(
                      top: 76,
                      right: AppSpacing.screenH,
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
                            onTap: _endCall,
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
