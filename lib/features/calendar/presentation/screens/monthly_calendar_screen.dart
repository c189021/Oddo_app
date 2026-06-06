import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../data/dummy/calendar_dummy.dart';
import '../../../../features/home/presentation/widgets/diary_start_modal.dart';
import '../../../../features/records/application/recorded_days_provider.dart';
import '../../../../features/records/application/viewing_date_provider.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../../../widgets/app_background.dart';
import '../../../../widgets/mascot_image.dart';
import '../../../../widgets/oddo_card.dart';
import '../../../../widgets/primary_button.dart';
import '../widgets/monthly_calendar.dart';

/// Screens 33/34 — 월간 캘린더·날짜 선택. One calendar; the bottom card +
/// CTA switch by whether the selected day has a record.
class MonthlyCalendarScreen extends ConsumerStatefulWidget {
  const MonthlyCalendarScreen({super.key});

  @override
  ConsumerState<MonthlyCalendarScreen> createState() =>
      _MonthlyCalendarScreenState();
}

class _MonthlyCalendarScreenState extends ConsumerState<MonthlyCalendarScreen> {
  DateTime _month = CalendarDummy.month;
  DateTime _selected = CalendarDummy.today;

  @override
  Widget build(BuildContext context) {
    final recorded = ref.watch(recordedDaysProvider);
    final isWritten = recorded
        .contains(DateTime(_selected.year, _selected.month, _selected.day));
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    onPressed: () {
                      if (context.canPop()) context.pop();
                    },
                  ),
                  const Expanded(
                    child: Text('날짜 선택',
                        textAlign: TextAlign.center,
                        style: AppTypography.subtitle),
                  ),
                  IconButton(
                    icon: const Icon(Icons.help_outline_rounded, size: 20),
                    onPressed: () {},
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 0,
                      AppSpacing.screenH, AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                                '캘린더에서 원하는 날짜를 선택해 주세요.\n작성한 날짜는 파란 배경으로 표시돼요.',
                                style: AppTypography.bodySecondary),
                          ),
                          // TODO: 캘린더를 안내하는 정면 포즈로 교체 예정
                          MascotImage(pose: MascotPose.front, size: 72),
                        ],
                      ),
                      Gap.h16,
                      MonthlyCalendar(
                        month: _month,
                        today: CalendarDummy.today,
                        selected: _selected,
                        recordedDays: recorded,
                        onSelect: (d) => setState(() => _selected = d),
                        onPrevMonth: () => setState(() =>
                            _month = DateTime(_month.year, _month.month - 1)),
                        onNextMonth: () => setState(() =>
                            _month = DateTime(_month.year, _month.month + 1)),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.screenH,
                    AppSpacing.xs, AppSpacing.screenH, AppSpacing.xs),
                child: Column(
                  children: [
                    _SelectCard(date: _selected, isWritten: isWritten),
                    Gap.h12,
                    isWritten
                        ? PrimaryButton(
                            label: '이 날짜 보기',
                            onPressed: () {
                              ref
                                  .read(viewingDateProvider.notifier)
                                  .set(_selected);
                              context.goNamed(AppRoute.homeWritten);
                            },
                          )
                        : PrimaryButton(
                            label: '이 날짜에 일기 작성하기',
                            onPressed: () =>
                                showDiaryStartModal(context, ref, date: _selected),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectCard extends StatelessWidget {
  const _SelectCard({required this.date, required this.isWritten});

  final DateTime date;
  final bool isWritten;

  @override
  Widget build(BuildContext context) {
    return OddoCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(DateFormatter.fullKoreanDate(date),
              style: AppTypography.body.copyWith(fontWeight: FontWeight.w700)),
          Gap.h8,
          if (isWritten)
            const Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _StatusChip(icon: Icons.menu_book_rounded, label: '일기 작성 완료'),
                _StatusChip(icon: Icons.insights_rounded, label: '리포트 있음'),
                _StatusChip(icon: Icons.chat_bubble_rounded, label: '상담 기록 있음'),
              ],
            )
          else
            Row(
              children: [
                const Icon(Icons.edit_note_rounded,
                    size: 20, color: AppColors.textTertiary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('아직 작성된 기록이 없어요',
                          style: AppTypography.bodySecondary
                              .copyWith(fontWeight: FontWeight.w600)),
                      const Text('이 날의 감정을 기록해보세요',
                          style: AppTypography.caption),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(label,
              style: AppTypography.caption.copyWith(
                  color: AppColors.primary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
