import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_providers.dart';
import '../data/models/app_user.dart';

/// View-facing auth state. Screens watch this; they never touch repositories
/// directly.
class AuthState {
  const AuthState({this.user, this.isLoading = false});

  final AppUser? user;
  final bool isLoading;

  bool get isLoggedIn => user != null;
  bool get onboardingDone => user?.onboardingDone ?? false;

  AuthState copyWith({AppUser? user, bool? isLoading, bool clearUser = false}) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Holds auth state and the login/logout business logic, separate from UI.
class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true);
    final user = await ref
        .read(authRepositoryProvider)
        .login(email: email, password: password);
    state = AuthState(user: user);
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AuthState();
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
