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

  final AppEnvironment environment;
  final String appName;
  final String apiBaseUrl;

  /// When true, repositories are backed by in-memory dummy data sources.
  /// Flip to false once real remote data sources are implemented.
  final bool useDummyData;

  bool get isDev => environment == AppEnvironment.dev;

  /// Development flavor — dummy data, no real API.
  static const AppConfig dev = AppConfig(
    environment: AppEnvironment.dev,
    appName: 'Oddo (dev)',
    apiBaseUrl: '',
    useDummyData: true,
  );

  /// Production flavor — placeholder values until the backend exists.
  static const AppConfig prod = AppConfig(
    environment: AppEnvironment.prod,
    appName: 'Oddo',
    apiBaseUrl: 'https://api.oddo.app',
    useDummyData: false,
  );
}
