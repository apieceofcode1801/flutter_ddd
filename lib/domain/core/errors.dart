import 'package:flutter_ddd/domain/core/failures.dart';

class UnExpectedValueError extends Error {
  final ValueFailure valueFailure;

  UnExpectedValueError(this.valueFailure);

  @override
  String toString() => Error.safeToString(
      'Encountered a ValueFailure at an unrecoverable point. Terminating. Failure was: $valueFailure');
}
