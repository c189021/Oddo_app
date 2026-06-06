import '../../../../core/constants/app_durations.dart';
import '../../../../data/dummy/dummy_seed.dart';
import '../models/app_user.dart';
import 'auth_data_source.dart';

/// In-memory auth backed by [DummySeed]. Simulates latency so loading states
/// behave like the real thing.
class AuthDummyDataSource implements AuthDataSource {
  AppUser? _current;

  Future<void> _delay() => Future<void>.delayed(AppDurations.dummyLatency);

  @override
  Future<AppUser?> currentUser() async {
    await _delay();
    return _current;
  }

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    await _delay();
    _current = DummySeed.user;
    return _current!;
  }

  @override
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String nickname,
  }) async {
    await _delay();
    _current = DummySeed.user.copyWith(
      email: email,
      nickname: nickname,
      onboardingDone: false,
    );
    return _current!;
  }

  @override
  Future<void> logout() async {
    await _delay();
    _current = null;
  }
}
