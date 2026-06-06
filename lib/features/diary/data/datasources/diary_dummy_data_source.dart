import '../../../../core/constants/app_durations.dart';
import '../../../../data/dummy/dummy_seed.dart';
import '../models/counsel_session.dart';
import '../models/diary_entry.dart';
import '../models/emotion_report.dart';
import 'diary_data_source.dart';

/// In-memory diary data backed by [DummySeed].
class DiaryDummyDataSource implements DiaryDataSource {
  Future<void> _delay() => Future<void>.delayed(AppDurations.dummyLatency);

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Future<List<DiaryEntry>> fetchEntries() async {
    await _delay();
    return DummySeed.diaryEntries;
  }

  @override
  Future<DiaryEntry?> fetchEntry(DateTime date) async {
    await _delay();
    for (final entry in DummySeed.diaryEntries) {
      if (_sameDay(entry.date, date)) return entry;
    }
    return null;
  }

  @override
  Future<EmotionReport?> fetchReport(DateTime date) async {
    await _delay();
    return _sameDay(DummySeed.reportJan14.date, date)
        ? DummySeed.reportJan14
        : null;
  }

  @override
  Future<CounselSession?> fetchCounsel(DateTime date) async {
    await _delay();
    return _sameDay(DummySeed.counselJan14.date, date)
        ? DummySeed.counselJan14
        : null;
  }
}
