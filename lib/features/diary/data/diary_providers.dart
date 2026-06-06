import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config_provider.dart';
import 'datasources/diary_data_source.dart';
import 'datasources/diary_dummy_data_source.dart';
import 'models/diary_entry.dart';
import 'repositories/diary_repository.dart';
import 'repositories/diary_repository_impl.dart';

/// Swap point: dummy vs real data source, chosen by [AppConfig].
final diaryDataSourceProvider = Provider<DiaryDataSource>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useDummyData) {
    return DiaryDummyDataSource();
  }
  throw UnimplementedError('DiaryRemoteDataSource is not implemented yet');
});

final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  return DiaryRepositoryImpl(ref.watch(diaryDataSourceProvider));
});

/// All diary entries (for the calendar / home record markers).
final diaryEntriesProvider = FutureProvider<List<DiaryEntry>>((ref) {
  return ref.watch(diaryRepositoryProvider).fetchEntries();
});
