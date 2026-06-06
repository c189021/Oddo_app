/// Post-counseling emotion report + behavior guide for a given date
/// (screens 46 / 49).
class EmotionReport {
  const EmotionReport({
    required this.date,
    required this.emotionDistribution,
    required this.emotionIntensity,
    required this.recoveryPossibility,
    required this.analysisComment,
    required this.behaviorGuides,
    required this.recommendedActivities,
  });

  final DateTime date;

  /// Emotion → share (0–1), e.g. {'속상함': 0.42, '후회': 0.28, ...}.
  final Map<String, double> emotionDistribution;

  final int emotionIntensity; // 0–100
  final int recoveryPossibility; // 0–100
  final String analysisComment;
  final List<String> behaviorGuides;
  final List<String> recommendedActivities;
}
