import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Central navigation guard (go_router `redirect`).
///
/// No-op for the prototype — every screen is reachable. The seam is here so
/// real gating can be added without touching individual routes:
///
/// ```dart
/// final auth = ref.read(authControllerProvider);
/// final loc = state.matchedLocation;
/// if (!auth.isLoggedIn && !loc.startsWith('/login')) return AppPath.login;
/// if (auth.isLoggedIn && !auth.onboardingDone && !loc.startsWith('/onboarding')) {
///   return AppPath.permission;
/// }
/// ```
///
/// When auth state can change at runtime, also pass a `refreshListenable`
/// (e.g. a `ChangeNotifier` bridged from the auth provider) to [GoRouter] so
/// redirects re-run on login/logout.
String? appRedirect(Ref ref, GoRouterState state) {
  return null;
}
