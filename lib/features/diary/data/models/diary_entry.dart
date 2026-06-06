/// One day's diary entry, produced by the Step 1–3 write flow.
class DiaryEntry {
  const DiaryEntry({
    required this.id,
    required this.date,
    required this.transcript,
    required this.summary,
    required this.emotionKeywords,
    this.videoUrl,
    this.emotionIntensity = 0,
    this.emotionStability = 0,
  });

  final String id;
  final DateTime date;

  /// Raw STT text the user reviewed/edited in Step 2.
  final String transcript;

  /// AI-generated summary written in diary style.
  final String summary;

  final List<String> emotionKeywords;

  /// URL/path of the generated short-form video (null until Step 3 finishes).
  final String? videoUrl;

  /// 0–100 scores shown on the Step 2 confirm screen.
  final int emotionIntensity;
  final int emotionStability;

  factory DiaryEntry.fromJson(Map<String, dynamic> json) => DiaryEntry(
        id: json['id'] as String,
        date: DateTime.parse(json['date'] as String),
        transcript: json['transcript'] as String,
        summary: json['summary'] as String,
        emotionKeywords: (json['emotionKeywords'] as List<dynamic>)
            .cast<String>(),
        videoUrl: json['videoUrl'] as String?,
        emotionIntensity: json['emotionIntensity'] as int? ?? 0,
        emotionStability: json['emotionStability'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'transcript': transcript,
        'summary': summary,
        'emotionKeywords': emotionKeywords,
        'videoUrl': videoUrl,
        'emotionIntensity': emotionIntensity,
        'emotionStability': emotionStability,
      };
}
