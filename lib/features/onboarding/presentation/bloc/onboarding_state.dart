part of 'onboarding_bloc.dart';

abstract class OnboardingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {}
class OnboardingLoading extends OnboardingState {}
class OnboardingRequired extends OnboardingState {}
class OnboardingComplete extends OnboardingState {}