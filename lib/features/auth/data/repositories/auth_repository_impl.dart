import '../datasources/auth_data_source.dart';
import '../models/app_user.dart';
import 'auth_repository.dart';

/// Default repository — delegates to a [AuthDataSource]. This is the layer that
/// would map low-level exceptions to domain [Failure]s and combine multiple
/// data sources (e.g. remote + local token cache) when the backend exists.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final AuthDataSource _dataSource;

  @override
  Future<AppUser?> currentUser() => _dataSource.currentUser();

  @override
  Future<AppUser> login({required String email, required String password}) =>
      _dataSource.login(email: email, password: password);

  @override
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String nickname,
  }) =>
      _dataSource.signUp(email: email, password: password, nickname: nickname);

  @override
  Future<void> logout() => _dataSource.logout();
}
