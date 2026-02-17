import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
/// Uses Equatable for value comparison
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Server-related failures (API errors)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Cache-related failures (Local storage errors)
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Network-related failures (No internet, timeout)
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Validation failures (Invalid input)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
