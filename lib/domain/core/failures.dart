import 'package:freezed_annotation/freezed_annotation.dart';
part 'failures.freezed.dart';

@freezed
abstract class ValueFailure<T> with _$ValueFailure<T> {
  const factory ValueFailure.invalidEmail({required String failedValue}) =
      _InvalidEmail<T>;
  const factory ValueFailure.shortPassword({required String failedValue}) =
      _ShortPassword<T>;
  const factory ValueFailure.exceedingLength(
      {required T failedValue, required int max}) = _ExceedingLength<T>;
  const factory ValueFailure.empty({required T failedValue}) = _Empty<T>;
  const factory ValueFailure.multiline({required T failedValue}) =
      _Multiline<T>;

  const factory ValueFailure.listTooLong(
      {required T failedValue, required int max}) = _ListToLong<T>;
}
