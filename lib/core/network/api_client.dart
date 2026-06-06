/// Placeholder for the HTTP client used by future remote data sources.
///
/// Intentionally empty for the prototype (everything runs on dummy data). When
/// the backend is ready, implement this with `dio`/`http`, inject the
/// `AppConfig.apiBaseUrl`, attach auth-token / logging interceptors, and back
/// the `*RemoteDataSource` classes with it.
abstract interface class ApiClient {
  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? query});

  Future<Map<String, dynamic>> post(String path, {Object? body});
}
