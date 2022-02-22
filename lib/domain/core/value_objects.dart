import 'package:dartz/dartz.dart';

import 'failures.dart';

abstract class ValueObject<T> {
  Either<ValueFailure<T>, T> get value;

  const ValueObject();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValueObject<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Value($value)';
}
