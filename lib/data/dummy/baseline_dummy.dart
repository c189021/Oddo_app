import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// One OS permission explained on the permission-rationale screen (09).
class PermissionInfo {
  const PermissionInfo(this.icon, this.title, this.description);
  final IconData icon;
  final String title;
  final String description;
}

/// One environment checklist row on the baseline ready screen (18).
class CheckItem {
  const CheckItem(this.icon, this.title, this.description);
  final IconData icon;
  final String title;
  final String description;
}

/// One measurement item on the baseline intro screen (17).
class MeasureItem {
  const MeasureItem(this.icon, this.title, this.description, this.duration);
  final IconData icon;
  final String title;
  final String description;
  final String duration;
}

/// Live progress row on the measuring screen (19).
class MeasureProgress {
  const MeasureProgress(this.label, this.value);
  final String label;
  final double value; // 0..1
}

/// A summary metric tile on the completion screen (21).
class BaselineMetric {
  const BaselineMetric(this.icon, this.label, this.value, this.color);
  final IconData icon;
  final String label;
  final String value;
  final Color color;
}

/// Static dummy content for the permission + baseline flow. Mirrors the
/// mockups and `_docs/02`. Replace with real data/state later.
abstract final class BaselineDummy {
  BaselineDummy._();

  // 09 — permission rationale.
  static const List<PermissionInfo> permissions = [
    PermissionInfo(
        Icons.camera_alt_outlined, '카메라', '얼굴 표정 측정과 영상 통화를 위해 필요해요.'),
    PermissionInfo(Icons.mic_none_rounded, '마이크', '목소리를 기록하고 감정을 분석하기 위해 필요해요.'),
    PermissionInfo(
        Icons.graphic_eq_rounded, '음성 인식', '말한 내용을 텍스트로 변환하기 위해 필요해요.'),
    PermissionInfo(
        Icons.notifications_none_rounded, '알림', '기록 리마인드와 소식을 전달하기 위해 필요해요.'),
    PermissionInfo(
        Icons.photo_library_outlined, '사진 저장', '완성된 숏폼 영상을 저장하기 위해 필요해요.'),
  ];

  // 17 — measurement items.
  static const List<MeasureItem> measureItems = [
    MeasureItem(Icons.sentiment_satisfied_alt_rounded, '얼굴 표정 측정',
        '다양한 표정을 자연스럽게 지어볼 거예요.', '약 2분'),
    MeasureItem(
        Icons.mic_none_rounded, '음성 측정', '몇 가지 주제에 대해 자유롭게 이야기해볼 거예요.', '약 3분'),
  ];

  static const List<String> introTips = [
    '편안한 장소에서 진행하면 좋아요.',
    '천천히, 자연스럽게 이야기해주세요.',
    '측정 중 너무 움직이지 않도록 해주세요.',
  ];

  // 18 — environment checklist (all good for the prototype).
  static const List<CheckItem> checklist = [
    CheckItem(Icons.center_focus_strong_rounded, '얼굴 위치', '얼굴이 화면 중앙에 있어요'),
    CheckItem(Icons.light_mode_rounded, '조명 상태', '주변이 너무 어둡지 않아요'),
    CheckItem(Icons.mic_none_rounded, '마이크 상태', '마이크가 정상적으로 연결됐어요'),
    CheckItem(Icons.volume_off_rounded, '주변 소음', '주변 소음이 크지 않아요'),
    CheckItem(Icons.verified_user_outlined, '카메라·마이크 권한', '권한이 모두 켜져 있어요'),
  ];

  // 19 — live measuring progress.
  static const List<MeasureProgress> measuringProgress = [
    MeasureProgress('얼굴 표정 측정', 0.60),
    MeasureProgress('음성 측정', 0.45),
  ];

  static const List<String> measuringTips = [
    '화면을 응시하며 자연스럽게 행동해주세요.',
  ];

  // 20 — analysis-in-progress items.
  static const List<String> analysisItems = [
    '얼굴 표정 기준',
    '음성 에너지 기준',
    '말하기 속도 기준',
  ];

  // 21 — completion summary lines (doc 21).
  static const List<String> completionSummary = [
    '얼굴 기준 데이터 저장 완료',
    '음성 기준 데이터 저장 완료',
    '감정 분석 준비 완료',
  ];

  // 21 — emotion-baseline summary metrics (mockup).
  static const List<BaselineMetric> metrics = [
    BaselineMetric(
        Icons.sentiment_satisfied_alt_rounded, '평균 감정', '6.2 / 10', AppColors.primary),
    BaselineMetric(Icons.graphic_eq_rounded, '음성 안정도', '72%', AppColors.success),
    BaselineMetric(Icons.insights_rounded, '표정 변화 다양성', '64%', AppColors.primary),
    BaselineMetric(Icons.schedule_rounded, '평균 측정 시간', '1분 48초', AppColors.warning),
  ];
}
