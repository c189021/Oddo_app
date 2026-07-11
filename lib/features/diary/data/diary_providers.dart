import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config_provider.dart';
import 'datasources/diary_data_source.dart';
import 'datasources/diary_dummy_data_source.dart';
import 'datasources/diary_remote_data_source.dart';
import 'models/counsel_session.dart';
import 'models/diary_entry.dart';
import 'models/emotion_report.dart';
import 'repositories/diary_repository.dart';
import 'repositories/diary_repository_impl.dart';

/// Swap point: dummy vs real data source, chosen by [AppConfig].
/// Tests override the config with `useDummyData: true` to stay off Firebase.
final diaryDataSourceProvider = Provider<DiaryDataSource>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useDummyData) {
    return DiaryDummyDataSource();
  }
  return DiaryRemoteDataSource();
});

final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  return DiaryRepositoryImpl(ref.watch(diaryDataSourceProvider));
});

/// The viewed date's diary entry (일기 상세, screen 48). Null = 기록 없음.
final diaryEntryProvider =
    FutureProvider.family<DiaryEntry?, DateTime>((ref, date) {
  return ref.watch(diaryRepositoryProvider).fetchEntry(date);
});

/// The viewed date's emotion report (감정 리포트, screen 49).
final emotionReportProvider =
    FutureProvider.family<EmotionReport?, DateTime>((ref, date) {
  return ref.watch(diaryRepositoryProvider).fetchReport(date);
});

/// The viewed date's counsel log (상담 기록, screen 50).
final counselSessionProvider =
    FutureProvider.family<CounselSession?, DateTime>((ref, date) {
  return ref.watch(diaryRepositoryProvider).fetchCounsel(date);
});
