part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckOnboarding extends OnboardingEvent {}
class CompleteOnboarding extends OnboardingEvent {}