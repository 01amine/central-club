part of 'history_bloc.dart';

@immutable
abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

class GetUserReservationsEvent extends HistoryEvent {}

class RefreshReservationsEvent extends HistoryEvent {}

class FilterReservationsEvent extends HistoryEvent {
  final ReservationFilter filter;

  const FilterReservationsEvent({required this.filter});

  @override
  List<Object> get props => [filter];
}

class SearchReservationsEvent extends HistoryEvent {
  final String query;

  const SearchReservationsEvent({required this.query});

  @override
  List<Object> get props => [query];
}

enum ReservationFilter {
  all,
  upcoming,
  past,
}