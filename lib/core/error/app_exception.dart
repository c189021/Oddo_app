/// Low-level exceptions thrown by data sources, before being mapped to a
/// [Failure] at the repository boundary.
class AppException implements Exception {
  const AppException(this.message, [this.cause]);
  final String message;
  final Object? cause;

  @override
  String toString() => 'AppException($message)';
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error', super.cause]);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server error', super.cause]);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Cache error', super.cause]);
}
