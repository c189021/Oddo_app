import '../models/counsel_session.dart';
import '../models/diary_entry.dart';
import '../models/emotion_report.dart';

/// Abstraction over diary/report/counsel data. Dummy now, remote later.
abstract interface class DiaryDataSource {
  Future<List<DiaryEntry>> fetchEntries();

  Future<DiaryEntry?> fetchEntry(DateTime date);

  Future<EmotionReport?> fetchReport(DateTime date);

  Future<CounselSession?> fetchCounsel(DateTime date);
}
