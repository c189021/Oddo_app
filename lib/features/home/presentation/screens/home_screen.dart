import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../data/dummy/home_dummy.dart';
import '../../../../data/dummy/records_dummy.dart';
import '../../../../features/onboarding/application/onboarding_controller.dart';
import '../../../../features/records/application/recorded_days_provider.dart';
import '../../../../features/records/application/viewing_date_provider.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../../../widgets/app_background.dart';
import '../../../../widgets/diary_bottom_nav.dart';
import '../../../../widgets/mascot_image.dart';
import '../../../../widgets/primary_button.dart';
import '../widgets/baseline_needed_dialog.dart';
import '../widgets/diary_start_modal.dart';
import '../widgets/home_header.dart';
import '../widgets/weekly_calendar.dart';

/// Screens 7 & 47 — 홈. One interactive component: the weekly bar re-centers on
/// the selected date (held in [viewingDateProvider]) and the main card switches
/// by whether that date has a diary record. Written day → video card +
/// [일기][리포트][상담] tab bar; not-written → the "write a diary" CTA card.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Before onboarding, auto-open the first-measurement popup once on entry.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !ref.read(onboardingCompleteProvider)) {
        showBaselineNeededDialog(context);
      }
    });
  }

  void _onWritePressed(bool onboarded, DateTime date) {
    if (onboarded) {
      showDiaryStartModal(context, ref, date: date);
    } else {
      showBaselineNeededDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(viewingDateProvider);
    final onboarded = ref.watch(onboardingCompleteProvider);
    final recorded = ref.watch(recordedDaysProvider);
    final written = recorded.contains(
      DateTime(selected.year, selected.month, selected.day),
    );
    // 7-day strip centered on the selected date (selected in the middle).
    final weekDays = List.generate(
      7,
      (i) => selected.add(Duration(days: i - 3)),
    );

    return Scaffold(
      bottomNavigationBar: written
          ? DiaryBottomNav(
              currentIndex: 0,
              onSelect: (i) {
                if (i == 1) context.goNamed(AppRoute.recordsReport);
                if (i == 2) context.goNamed(AppRoute.recordsCounsel);
              },
            )
          : null,
      body: AppBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenH,
                  AppSpacing.xs,
                  AppSpacing.screenH,
                  0,
                ),
                child: HomeHeader(month: selected),
              ),
              Gap.h12,
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenH,
                ),
                child: WeeklyCalendar(
                  days: weekDays,
                  today: HomeDummy.today,
                  selected: selected,
                  recordedDays: recorded,
                  onSelect: (d) =>
                      ref.read(viewingDateProvider.notifier).set(d),
                ),
              ),
              Expanded(
                // 위 기준 고정 정렬: 작성일에만 하단 탭바가 생겨도 카드가
                // 세로로 밀리지 않도록, 화면 중앙 정렬 대신 주간 바 아래
                // 고정 오프셋에 카드를 둔다.
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenH,
                      AppSpacing.xl,
                      AppSpacing.screenH,
                      AppSpacing.md,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // TODO: 카드 뒤에서 얼굴·손을 내미는 정면 포즈로 교체 예정
                        const Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: MascotImage(
                              pose: MascotPose.front,
                              size: 150,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 96),
                          child: _HomeCard(
                            date: selected,
                            written: written,
                            onReadDiary: () =>
                                context.goNamed(AppRoute.recordsDiary),
                            onWrite: () => _onWritePressed(onboarded, selected),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The home's single main card. Both states render inside one shell via
/// [IndexedStack], which sizes itself to the larger child (the written
/// layout) — so the card's size and position never change when the selected
/// date flips between written/unwritten; only the content swaps.
class _HomeCard extends StatelessWidget {
  const _HomeCard({
    required this.date,
    required this.written,
    required this.onReadDiary,
    required this.onWrite,
  });

  final DateTime date;
  final bool written;
  final VoidCallback onReadDiary;
  final VoidCallback onWrite;

  @override
  Widget build(BuildContext context) {
    return _HomeCardShell(
      child: IndexedStack(
        index: written ? 0 : 1,
        children: [
          _WrittenContent(date: date, onReadDiary: onReadDiary),
          // Positioned.fill: 스택 크기(=작성일 내용)에 정확히 맞춰져,
          // 미작성 내용이 카드 전체 높이를 쓸 수 있다 (날짜 상단 / 히어로
          // 중앙 / 버튼 하단).
          Positioned.fill(
            child: _WriteContent(date: date, onWrite: onWrite),
          ),
        ],
      ),
    );
  }
}

/// Not-written state — prompt to start a diary for [date]. 파란 날짜는
/// 작성일 카드와 같은 스타일로 좌상단, 히어로(아이콘+문구)는 중앙, 작성
/// 버튼은 하단 고정.
class _WriteContent extends StatelessWidget {
  const _WriteContent({required this.date, required this.onWrite});

  final DateTime date;
  final VoidCallback onWrite;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          DateFormatter.monthDay(date),
          style: AppTypography.title.copyWith(color: AppColors.primary),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.backgroundAlt,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit_note_rounded,
                  color: AppColors.textTertiary,
                ),
              ),
              Gap.h12,
              const Text(
                HomeDummy.writeCardTitle,
                textAlign: TextAlign.center,
                style: AppTypography.title,
              ),
              Gap.h8,
              const Text(
                HomeDummy.writeCardSubtitle,
                textAlign: TextAlign.center,
                style: AppTypography.bodySecondary,
              ),
            ],
          ),
        ),
        PrimaryButton(label: '일기 작성하기', onPressed: onWrite),
      ],
    );
  }
}

/// Written state — recorded-day card content with the generated video +
/// read button.
class _WrittenContent extends StatelessWidget {
  const _WrittenContent({required this.date, required this.onReadDiary});

  final DateTime date;
  final VoidCallback onReadDiary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          DateFormatter.monthDay(date),
          style: AppTypography.title.copyWith(color: AppColors.primary),
        ),
        Gap.h4,
        const Text(
          RecordsDummy.homeWrittenTitle,
          style: AppTypography.bodySecondary,
        ),
        Gap.h16,
        GestureDetector(
          onTap: () => context.pushNamed(AppRoute.shortformPlayer),
          child: ClipRRect(
            borderRadius: AppRadius.card,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: AppColors.callBackground),
                  // TODO: 일기 쓰는 장면 영상 썸네일로 교체 예정
                  const Center(
                    child: MascotImage(
                      pose: MascotPose.writing,
                      size: 96,
                      onDark: true,
                    ),
                  ),
                  const Center(
                    child: Icon(
                      Icons.play_circle_fill_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Gap.h16,
        GestureDetector(
          onTap: onReadDiary,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.backgroundAlt,
              borderRadius: AppRadius.button,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.menu_book_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 10),
                Text(
                  '작성한 일기 읽기',
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Shared white rounded card shell for both home states.
class _HomeCardShell extends StatelessWidget {
  const _HomeCardShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.card,
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
