import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/usecases/clear_token.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/signup_user.dart';
import '../../domain/usecases/save_token.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final SignupUser signupUser;
  final SaveToken saveToken;
  final ClearToken clearToken;

  AuthBloc({
    required this.loginUser,
    required this.signupUser,
    required this.saveToken,
    required this.clearToken,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUser(
      LoginParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (authResponse) async {
        await saveToken(authResponse.token);
        emit(AuthSuccess(authResponse: authResponse));
      },
    );
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signupUser(
      SignupParams(
        fullName: event.fullName,
        birthday: event.birthday,
        phoneNumber: event.phoneNumber,
        email: event.email,
        password: event.password,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (authResponse) async {
        await saveToken(authResponse.token);
        emit(AuthSuccess(authResponse: authResponse));
      },
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await clearToken(NoParams());
    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (_) => emit(AuthInitial()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is CacheFailure) {
      return 'Cache Error';
    } else {
      return 'Unexpected Error';
    }
  }
}
