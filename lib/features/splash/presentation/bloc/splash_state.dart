part of 'splash_bloc.dart';

@immutable
abstract class SplashState extends Equatable {
  const SplashState();
  
  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashState {
  const SplashInitial();
}

class SplashLoading extends SplashState {
  const SplashLoading();
}

class SplashLoaded extends SplashState {
  final String route;
  
  const SplashLoaded({required this.route});
  
  @override
  List<Object> get props => [route];
}

class SplashError extends SplashState {
  final String message;
  
  const SplashError({required this.message});
  
  @override
  List<Object> get props => [message];
}