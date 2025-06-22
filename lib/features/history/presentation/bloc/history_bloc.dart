import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../reserve_field/domain/entities/reservation.dart';
import '../../../reserve_field/domain/usecase/get_user_reservations.dart';

part 'history_event.dart';
part 'history_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String NETWORK_FAILURE_MESSAGE = 'Network Failure';
const String UNEXPECTED_FAILURE_MESSAGE = 'Unexpected Error';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetUserReservations getUserReservations;

  HistoryBloc({required this.getUserReservations}) : super(HistoryInitial()) {
    on<GetUserReservationsEvent>(_onGetUserReservationsEvent);
    on<RefreshReservationsEvent>(_onRefreshReservationsEvent);
    on<FilterReservationsEvent>(_onFilterReservationsEvent);
    on<SearchReservationsEvent>(_onSearchReservationsEvent);
  }

  Future<void> _onGetUserReservationsEvent(
    GetUserReservationsEvent event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    await _loadReservations(emit);
  }

  Future<void> _onRefreshReservationsEvent(
    RefreshReservationsEvent event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryRefreshing(reservations: _getCurrentReservations()));
    await _loadReservations(emit);
  }

  Future<void> _onFilterReservationsEvent(
    FilterReservationsEvent event,
    Emitter<HistoryState> emit,
  ) async {
    final currentReservations = _getCurrentReservations();
    List<Reservation> filteredReservations;

    switch (event.filter) {
      case ReservationFilter.all:
        filteredReservations = currentReservations;
        break;
      case ReservationFilter.upcoming:
        filteredReservations = currentReservations.where((reservation) {
          final reservationDate = DateTime.tryParse(reservation.date.split('/').reversed.join('-'));
          return reservationDate != null && reservationDate.isAfter(DateTime.now());
        }).toList();
        break;
      case ReservationFilter.past:
        filteredReservations = currentReservations.where((reservation) {
          final reservationDate = DateTime.tryParse(reservation.date.split('/').reversed.join('-'));
          return reservationDate != null && reservationDate.isBefore(DateTime.now());
        }).toList();
        break;
      case ReservationFilter.confirmed:
        filteredReservations = currentReservations.where((reservation) => 
          reservation.status.toLowerCase() == 'confirmed').toList();
        break;
      case ReservationFilter.cancelled:
        filteredReservations = currentReservations.where((reservation) => 
          reservation.status.toLowerCase() == 'cancelled').toList();
        break;
    }

    emit(HistoryFiltered(
      reservations: filteredReservations,
      allReservations: currentReservations,
      currentFilter: event.filter,
    ));
  }

  Future<void> _onSearchReservationsEvent(
    SearchReservationsEvent event,
    Emitter<HistoryState> emit,
  ) async {
    final currentReservations = _getCurrentReservations();
    
    if (event.query.isEmpty) {
      emit(HistoryLoaded(reservations: currentReservations));
      return;
    }

    final searchResults = currentReservations.where((reservation) {
      final query = event.query.toLowerCase();
      return reservation.fieldName.toLowerCase().contains(query) ||
             reservation.fieldType.toLowerCase().contains(query) ||
             reservation.date.contains(query) ||
             reservation.status.toLowerCase().contains(query);
    }).toList();

    emit(HistorySearched(
      reservations: searchResults,
      allReservations: currentReservations,
      searchQuery: event.query,
    ));
  }

  Future<void> _loadReservations(Emitter<HistoryState> emit) async {
    final failureOrReservations = await getUserReservations(NoParams());
    failureOrReservations.fold(
      (failure) => emit(HistoryError(message: _mapFailureToMessage(failure))),
      (reservations) => emit(HistoryLoaded(reservations: reservations)),
    );
  }

  List<Reservation> _getCurrentReservations() {
    final currentState = state;
    if (currentState is HistoryLoaded) {
      return currentState.reservations;
    } else if (currentState is HistoryFiltered) {
      return currentState.allReservations;
    } else if (currentState is HistorySearched) {
      return currentState.allReservations;
    } else if (currentState is HistoryRefreshing) {
      return currentState.reservations;
    }
    return [];
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return UNEXPECTED_FAILURE_MESSAGE;
    }
  }
}