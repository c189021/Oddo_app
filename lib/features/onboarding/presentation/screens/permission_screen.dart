import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../data/dummy/baseline_dummy.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../../../widgets/app_background.dart';
import '../../../../widgets/icon_info_tile.dart';
import '../../../../widgets/mascot_image.dart';
import '../../../../widgets/oddo_card.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/security_note.dart';

/// Screen 9 — 권한 요청 안내. Explains why each OS permission is needed before
/// the system prompts. → 권한 허용하기 → 튜토리얼 1/5.
class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenH, 0, AppSpacing.screenH, AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _header(context),
                      Gap.h20,
                      OddoCard(
                        child: Column(
                          children: [
                            for (var i = 0;
                                i < BaselineDummy.permissions.length;
                                i++) ...[
                              if (i > 0)
                                const Divider(
                                    color: AppColors.divider, height: 1),
                              IconInfoTile(
                                icon: BaselineDummy.permissions[i].icon,
                                title: BaselineDummy.permissions[i].title,
                                description:
                                    BaselineDummy.permissions[i].description,
                                trailing: const Icon(
                                    Icons.chevron_right_rounded,
                                    color: AppColors.textTertiary),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Gap.h16,
                      const SecurityNote(
                        text: '모든 권한은 안전하게 보호되며, 기능 제공 목적 외에는 사용되지 않아요.',
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenH, AppSpacing.xs, AppSpacing.screenH, AppSpacing.xs),
                child: PrimaryButton(
                  label: '권한 허용하기',
                  onPressed: () => context.pushNamed(AppRoute.tutorialIntro),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () {
                if (context.canPop()) context.pop();
              },
            ),
            Gap.h8,
            const Padding(
              padding: EdgeInsets.only(right: 96),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('권한 안내', style: AppTypography.display),
                  Gap.h8,
                  Text('Oddo가 정확하게 기록하고 분석할 수 있도록\n다음 권한이 필요해요.',
                      style: AppTypography.bodySecondary),
                ],
              ),
            ),
          ],
        ),
        const Positioned(
          top: 36,
          right: -8,
          // TODO: 방패를 든 보호 포즈로 교체 예정 (character_sheet 기반 방패 들기)
          child: MascotImage(pose: MascotPose.shield, size: 116),
        ),
      ],
    );
  }
}
