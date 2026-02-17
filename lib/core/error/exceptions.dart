/// Base exception class
class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

/// Server exception (API errors)
class ServerException extends AppException {
  const ServerException(super.message);
}

/// Cache exception (Local storage errors)
class CacheException extends AppException {
  const CacheException(super.message);
}

/// Network exception (Connection errors)
class NetworkException extends AppException {
  const NetworkException(super.message);
}
