import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../data/dummy/auth_dummy.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../../../widgets/app_background.dart';
import '../../../../widgets/oddo_card.dart';
import '../../../../widgets/oddo_text_field.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/security_note.dart';
import '../widgets/auth_form_header.dart';
import '../widgets/gender_selector.dart';
import '../widgets/terms_agreement_section.dart';

/// Screen 4 — 소셜 로그인 추가 정보 입력. First-time social users complete
/// required profile info → home.
class SocialExtraInfoScreen extends StatelessWidget {
  const SocialExtraInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH, AppSpacing.xs, AppSpacing.screenH, AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // TODO: 반갑게 인사하는 포즈로 교체 예정 (character_sheet 12.하트 들기 / 10.인사)
                const AuthFormHeader(
                  title: '추가 정보 입력',
                  subtitle: '더 나은 맞춤 대화를 위해\n몇 가지만 알려주세요.',
                  mascotPose: MascotPose.heart,
                ),
                Gap.h20,
                const OddoCard(
                  child: Column(
                    children: [
                      OddoTextField(
                        hint: AuthDummy.nicknameHint,
                        prefixIcon: Icons.person_outline_rounded,
                        suffix: Text('0/10', style: AppTypography.caption),
                      ),
                      Gap.h12,
                      OddoTextField(
                        hint: AuthDummy.birthHint,
                        prefixIcon: Icons.calendar_today_outlined,
                        readOnly: true,
                        suffix: Icon(Icons.calendar_month_rounded,
                            size: 20, color: AppColors.primary),
                      ),
                      Gap.h12,
                      GenderSelector(),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                        child: Divider(color: AppColors.divider),
                      ),
                      TermsAgreementSection(),
                    ],
                  ),
                ),
                Gap.h24,
                PrimaryButton(
                  label: '시작하기',
                  onPressed: () => context.goNamed(AppRoute.home),
                ),
                Gap.h16,
                const SecurityNote(
                  text: '입력하신 정보는 안전하게 보호되며, 감정분석과 맞춤 대화 서비스에 사용됩니다.',
                  center: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
