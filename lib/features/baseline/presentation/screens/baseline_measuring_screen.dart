import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../data/dummy/baseline_dummy.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../../../widgets/mascot_image.dart';
import '../../../../widgets/tip_card.dart';
import '../widgets/baseline_header.dart';

/// Screen 19 — 얼굴·음성 Baseline 측정 중. Video-call style. Auto-advances to
/// the analysis screen after a dummy delay (tap the status bar to skip).
class BaselineMeasuringScreen extends StatefulWidget {
  const BaselineMeasuringScreen({super.key});

  @override
  State<BaselineMeasuringScreen> createState() =>
      _BaselineMeasuringScreenState();
}

class _BaselineMeasuringScreenState extends State<BaselineMeasuringScreen> {
  Timer? _timer;
  bool _advanced = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 4), _advance);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _advance() {
    if (_advanced || !mounted) return;
    _advanced = true;
    context.pushReplacementNamed(AppRoute.baselineAnalyzing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.callBackground,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: BaselineHeader(
                title: '베이스라인 측정 2/2',
                stepLabels: ['안내 진행', '측정 진행'],
                activeStep: 1,
                dark: true,
                leadingIcon: Icons.close_rounded,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.screenH,
                    AppSpacing.md, AppSpacing.screenH, AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('측정 중이에요!',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.callTextPrimary)),
                    Gap.h8,
                    const Text('얼굴 표정과 음성 데이터를 수집하고 있어요.\n잠시만 편안한 상태로 기다려주세요.',
                        style: TextStyle(
                            fontSize: 14, color: AppColors.callTextSecondary)),
                    Gap.h16,
                    const _PreviewCard(),
                    Gap.h24,
                    const Text('진행 상황',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.callTextPrimary)),
                    Gap.h12,
                    for (final p in BaselineDummy.measuringProgress) ...[
                      _ProgressRow(progress: p),
                      Gap.h16,
                    ],
                    const TipCard(
                        tips: BaselineDummy.measuringTips, dark: true),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenH,
                  AppSpacing.xs, AppSpacing.screenH, AppSpacing.xs),
              child: _StatusBar(onTap: _advance),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: const BoxDecoration(
        color: AppColors.callSurface,
        borderRadius: AppRadius.card,
      ),
      child: const Stack(
        children: [
          // TODO: 손 흔드는 측정용 정면 포즈로 교체 예정 (character_sheet 10.인사)
          Center(
              child: MascotImage(pose: MascotPose.waving, size: 150, onDark: true)),
          Positioned(top: 12, left: 12, child: _LiveChip()),
          Positioned(top: 12, right: 12, child: _TimerChip(time: '00:28')),
          Positioned(bottom: 14, right: 14, child: _Waveform()),
        ],
      ),
    );
  }
}

class _LiveChip extends StatelessWidget {
  const _LiveChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.callBackground,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
                color: AppColors.error, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text('LIVE',
              style: AppTypography.caption.copyWith(
                  color: AppColors.callTextPrimary,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _TimerChip extends StatelessWidget {
  const _TimerChip({required this.time});
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.callBackground,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.schedule_rounded,
              size: 13, color: AppColors.callTextSecondary),
          const SizedBox(width: 4),
          Text(time,
              style: AppTypography.caption
                  .copyWith(color: AppColors.callTextPrimary)),
        ],
      ),
    );
  }
}

class _Waveform extends StatelessWidget {
  const _Waveform();

  static const List<double> _bars = [10, 18, 8, 22, 14, 26, 12, 20];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (final h in _bars)
          Container(
            width: 3,
            height: h,
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({required this.progress});
  final MeasureProgress progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(progress.label,
                style: const TextStyle(
                    fontSize: 14, color: AppColors.callTextPrimary)),
            const Spacer(),
            Text('${(progress.value * 100).round()}%',
                style: AppTypography.bodySecondary.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: LinearProgressIndicator(
            value: progress.value,
            minHeight: 8,
            backgroundColor: AppColors.callSurface,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.callSurface,
      borderRadius: AppRadius.button,
      child: InkWell(
        borderRadius: AppRadius.button,
        onTap: onTap,
        child: Container(
          height: 56,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.callTextSecondary),
              ),
              const SizedBox(width: 10),
              Text('측정 중... 잠시만 기다려주세요',
                  style: AppTypography.button
                      .copyWith(color: AppColors.callTextSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
