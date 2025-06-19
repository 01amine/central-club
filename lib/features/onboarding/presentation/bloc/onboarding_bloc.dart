import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_onboarding_seen.dart';
import '../../domain/usecases/save_onboarding_seen.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final GetOnboardingSeen getSeen;
  final SaveOnboardingSeen saveSeen;

  OnboardingBloc({required this.getSeen, required this.saveSeen})
      : super(OnboardingInitial()) {
    on<CheckOnboarding>((event, emit) async {
      emit(OnboardingLoading());
      final seen = await getSeen();
      if (seen) {
        emit(const OnboardingComplete(route: '/login')); 
      } else {
        emit(OnboardingRequired());
      }
    });
    on<CompleteOnboarding>((event, emit) async {
      await saveSeen();
      emit(const OnboardingComplete(route: '/login')); 
    });
  }
}