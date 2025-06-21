import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../onboarding/domain/usecases/get_onboarding_seen.dart';
import '../../domain/is_user_loged_in.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final GetOnboardingSeen getOnboardingSeen;
  final IsUserLoggedIn isUserLoggedIn;

  SplashBloc({required this.getOnboardingSeen, required this.isUserLoggedIn})
      : super(const SplashInitial()) {
    on<InitializeApp>(_onInitializeApp);
  }

  Future<void> _onInitializeApp(
    InitializeApp event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashLoading());
    try {
      await Future.delayed(const Duration(seconds: 5));

      final hasSeenOnboarding = await getOnboardingSeen();

      if (hasSeenOnboarding) {
        final loggedInResult = await isUserLoggedIn(NoParams());
        loggedInResult.fold(
            (failure) => emit(SplashError(
                message: 'Error checking login status: ${failure.toString()}')),
            (loggedIn) {
          if (loggedIn) {
            emit(const SplashLoaded(route: '/home'));
          } else {
            emit(const SplashLoaded(route: '/login'));
          }
        });
      } else {
        emit(const SplashLoaded(route: '/onboarding'));
      }
    } catch (e) {
      emit(SplashError(message: e.toString()));
    }
  }
}
