part of 'history_bloc.dart';

@immutable
abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryRefreshing extends HistoryState {
  final List<Reservation> reservations;

  const HistoryRefreshing({required this.reservations});

  @override
  List<Object> get props => [reservations];
}

class HistoryLoaded extends HistoryState {
  final List<Reservation> reservations;

  const HistoryLoaded({required this.reservations});

  @override
  List<Object> get props => [reservations];
}

class HistoryFiltered extends HistoryState {
  final List<Reservation> reservations;
  final List<Reservation> allReservations;
  final ReservationFilter currentFilter;

  const HistoryFiltered({
    required this.reservations,
    required this.allReservations,
    required this.currentFilter,
  });

  @override
  List<Object> get props => [reservations, allReservations, currentFilter];
}

class HistorySearched extends HistoryState {
  final List<Reservation> reservations;
  final List<Reservation> allReservations;
  final String searchQuery;

  const HistorySearched({
    required this.reservations,
    required this.allReservations,
    required this.searchQuery,
  });

  @override
  List<Object> get props => [reservations, allReservations, searchQuery];
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError({required this.message});

  @override
  List<Object> get props => [message];
}
