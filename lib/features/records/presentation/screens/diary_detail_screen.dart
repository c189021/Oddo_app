import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../data/dummy/records_dummy.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../../../widgets/mascot_image.dart';
import '../../application/viewing_date_provider.dart';
import '../widgets/record_top_bar.dart';

/// Screen 48 — 일기 상세 (일기 tab of the written-day context).
class DiaryDetailScreen extends ConsumerWidget {
  const DiaryDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(viewingDateProvider);
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const RecordTopBar(title: '일기 상세'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenH,
                  AppSpacing.xs, AppSpacing.screenH, AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: AppRadius.card,
                    child: AspectRatio(
                      aspectRatio: 16 / 10,
                      child: Container(
                        color: AppColors.primarySoft,
                        alignment: Alignment.center,
                        // TODO: 노을 지는 창가에서 일기 쓰는 장면으로 교체 예정
                        child: const MascotImage(
                            pose: MascotPose.writing, size: 130),
                      ),
                    ),
                  ),
                  Gap.h16,
                  Row(
                    children: [
                      Text(RecordsDummy.diaryDateLabel(date),
                          style: AppTypography.title
                              .copyWith(color: AppColors.primary)),
                      const Spacer(),
                      const _MoodChip(RecordsDummy.diaryMood),
                    ],
                  ),
                  Gap.h4,
                  Text(RecordsDummy.diaryWrittenAt(date),
                      style: AppTypography.caption),
                  Gap.h16,
                  Text(RecordsDummy.diaryBody,
                      style: AppTypography.body.copyWith(height: 1.7)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodChip extends StatelessWidget {
  const _MoodChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(label,
          style: AppTypography.caption.copyWith(
              color: AppColors.primary, fontWeight: FontWeight.w700)),
    );
  }
}
