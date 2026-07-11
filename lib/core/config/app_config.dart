/// Build/runtime environments. Only [dev] is wired up for the prototype;
/// [staging]/[prod] exist so the seam is ready when real backends arrive.
enum AppEnvironment { dev, staging, prod }

/// Immutable per-environment configuration.
///
/// This is the single place that knows "which backend / which data source".
/// A flavor entrypoint (e.g. `main.dart` for dev, a future `main_prod.dart`)
/// passes the right instance into `bootstrap()`, which overrides
/// `appConfigProvider`. Nothing else in the app reads environment flags
/// directly — they read this config through the provider.
class AppConfig {
  const AppConfig({
    required this.environment,
    required this.appName,
    required this.apiBaseUrl,
    required this.useDummyData,
  });

  /// Kakao SDK native app key (public client identifier, same for all
  /// flavors). Must match the scheme registered in AndroidManifest/Info.plist.
  static const String kakaoNativeAppKey = '8b00254b04d1af4e710681a3184a48f9';

  final AppEnvironment environment;
  final String appName;
  final String apiBaseUrl;

  /// When true, repositories are backed by in-memory dummy data sources.
  /// Flip to false once real remote data sources are implemented.
  final bool useDummyData;

  bool get isDev => environment == AppEnvironment.dev;

  /// Development flavor. Real Firebase auth/data since Phase 1; screens not
  /// yet migrated to repositories still read the static dummies directly.
  /// (Tests override this with `useDummyData: true` to stay off Firebase.)
  static const AppConfig dev = AppConfig(
    environment: AppEnvironment.dev,
    appName: 'Oddo (dev)',
    apiBaseUrl: '',
    useDummyData: false,
  );

  /// Production flavor. The AI-server base URL is injected at build time so
  /// no real endpoint is hardcoded in the repo:
  /// `flutter run -t lib/main_prod.dart --dart-define=ODDO_API_BASE_URL=https://...`
  static const AppConfig prod = AppConfig(
    environment: AppEnvironment.prod,
    appName: 'Oddo',
    apiBaseUrl: String.fromEnvironment('ODDO_API_BASE_URL'),
    useDummyData: false,
  );
}
