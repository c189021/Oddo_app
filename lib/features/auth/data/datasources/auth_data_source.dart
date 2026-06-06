import '../models/app_user.dart';

/// Abstraction over where auth data comes from. A dummy implementation backs
/// the prototype; a remote implementation (HTTP + token storage) replaces it
/// later without changing the repository or UI.
abstract interface class AuthDataSource {
  Future<AppUser?> currentUser();

  Future<AppUser> login({required String email, required String password});

  Future<AppUser> signUp({
    required String email,
    required String password,
    required String nickname,
  });

  Future<void> logout();
}
