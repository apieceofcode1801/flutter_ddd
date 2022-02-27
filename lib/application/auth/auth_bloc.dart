import 'package:bloc/bloc.dart';
import 'package:flutter_ddd/domain/auth/i_auth_facade.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthFacade _authFacade;
  AuthBloc(this._authFacade) : super(_Initial()) {
    on<AuthEvent>((event, emit) {
      event.map(authCheckRequested: (e) async {
        final userOption = await _authFacade.getSignedUser();
        userOption.fold(() => emit(const AuthState.unAuthenticated()),
            (_) => emit(const AuthState.authenticated()));
      }, signedOut: (e) async {
        await _authFacade.signOut();
        emit(const AuthState.unAuthenticated());
      });
    });
  }
}
