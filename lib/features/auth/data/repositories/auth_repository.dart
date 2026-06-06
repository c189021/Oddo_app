import '../models/app_user.dart';

/// What the app needs from auth, independent of the data source. The UI/state
/// layer depends only on this interface.
abstract interface class AuthRepository {
  Future<AppUser?> currentUser();

  Future<AppUser> login({required String email, required String password});

  Future<AppUser> signUp({
    required String email,
    required String password,
    required String nickname,
  });

  Future<void> logout();
}
