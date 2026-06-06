import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config_provider.dart';
import 'datasources/auth_data_source.dart';
import 'datasources/auth_dummy_data_source.dart';
import 'repositories/auth_repository.dart';
import 'repositories/auth_repository_impl.dart';

/// THE swap point: dummy vs real data source, chosen by [AppConfig].
/// Implement `AuthRemoteDataSource` and return it here when the backend lands.
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useDummyData) {
    return AuthDummyDataSource();
  }
  throw UnimplementedError('AuthRemoteDataSource is not implemented yet');
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authDataSourceProvider));
});
