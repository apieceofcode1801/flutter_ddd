import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_ddd/domain/auth/auth_failure.dart';
import 'package:flutter_ddd/domain/auth/i_auth_facade.dart';
import 'package:flutter_ddd/domain/auth/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';
part 'sign_in_form_bloc.freezed.dart';

@injectable
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;
  SignInFormBloc(this._authFacade) : super(SignInFormState.initial()) {
    on<SignInFormEvent>((event, emit) {
      event.map(emailChanged: (e) async {
        emit(state.copyWith(
            emailAddress: EmailAddress(e.emailStr),
            authFailureOrSuccess: none()));
      }, passwordChanged: (e) async {
        emit(state.copyWith(
            password: Password(e.passwordStr), authFailureOrSuccess: none()));
      }, registerWithEmailAndPasswordPressed: (e) async {
        _performAuthActionWithEmailAndPassword(
            emit, _authFacade.registerWithEmailAndPassword);
      }, signInWithEmailAndPasswordPressed: (e) async {
        _performAuthActionWithEmailAndPassword(
            emit, _authFacade.signInWithEmailAndPassword);
      }, signInWithGooglePressed: (e) async {
        state.copyWith(isSubmitting: true, authFailureOrSuccess: none());
        final result = await _authFacade.signInWithGoogle();
        state.copyWith(isSubmitting: false, authFailureOrSuccess: some(result));
      });
    });
  }

  _performAuthActionWithEmailAndPassword(
      Function(SignInFormState state) emit,
      Future<Either<AuthFailure, Unit>> Function(
              {required EmailAddress email, required Password password})
          forwardCalled) async {
    if (state.emailAddress.isValid && state.password.isValid) {
      emit(state.copyWith(isSubmitting: true, authFailureOrSuccess: none()));
      final result = await forwardCalled(
          email: state.emailAddress, password: state.password);
      emit(state.copyWith(
          isSubmitting: false, authFailureOrSuccess: some(result)));
      return;
    }
    emit(state.copyWith(showErrorMessage: true, authFailureOrSuccess: none()));
  }
}
