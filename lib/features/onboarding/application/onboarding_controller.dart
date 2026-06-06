import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the user has finished first-run onboarding
/// (튜토리얼 → Baseline 측정 → 심리테스트 → 페르소나 설정).
///
/// Drives the home screen: while `false`, the first-measurement popup auto-opens
/// and the "일기 작성하기" CTA re-opens it; once `true`, the popup is gone and the
/// CTA goes straight to the diary-writing flow.
///
/// NOTE: in-memory only for the prototype — resets on app restart. For real use,
/// persist it (e.g. AppUser.onboardingDone + secure/local storage) and read that
/// here instead.
class OnboardingController extends Notifier<bool> {
  @override
  bool build() => false;

  void markComplete() => state = true;
}

final onboardingCompleteProvider =
    NotifierProvider<OnboardingController, bool>(OnboardingController.new);
