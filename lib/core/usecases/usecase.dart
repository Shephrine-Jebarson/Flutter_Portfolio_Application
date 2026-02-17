import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Base class for all use cases
/// Type: Return type of the use case
/// Params: Parameters required for the use case
abstract class UseCase<Type, Params> {
  /// Execute the use case
  /// Returns Either<Failure, Type>
  /// Left = Failure, Right = Success
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case with no parameters
class NoParams {
  const NoParams();
}
