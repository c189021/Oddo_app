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
import '../widgets/auth_form_header.dart';
import '../widgets/gender_selector.dart';
import '../widgets/terms_agreement_section.dart';

/// Screen 3 — 회원가입. Email/pw/nickname/birth/gender/terms → home.
class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
                // TODO: 하트를 든 환영 포즈로 교체 예정 (character_sheet 12.하트 들기)
                const AuthFormHeader(
                  title: '회원가입',
                  subtitle: 'Oddo와 함께\n오늘 감정을 기록해요.',
                  mascotPose: MascotPose.heart,
                ),
                Gap.h20,
                const OddoCard(
                  child: Column(
                    children: [
                      OddoTextField(
                        hint: AuthDummy.emailHint,
                        prefixIcon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      Gap.h12,
                      OddoTextField(
                        hint: AuthDummy.passwordHint,
                        prefixIcon: Icons.lock_outline_rounded,
                        obscure: true,
                      ),
                      Gap.h12,
                      OddoTextField(
                        hint: AuthDummy.passwordConfirmHint,
                        prefixIcon: Icons.lock_outline_rounded,
                        obscure: true,
                      ),
                      Gap.h12,
                      OddoTextField(
                        hint: AuthDummy.nicknameHint,
                        prefixIcon: Icons.person_outline_rounded,
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
                  label: '회원가입 완료',
                  onPressed: () => context.goNamed(AppRoute.home),
                ),
                Gap.h12,
                _loginRow(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('이미 계정이 있으신가요?', style: AppTypography.bodySecondary),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () =>
              context.canPop() ? context.pop() : context.goNamed(AppRoute.login),
          child: Text(
            '로그인',
            style: AppTypography.bodySecondary
                .copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
