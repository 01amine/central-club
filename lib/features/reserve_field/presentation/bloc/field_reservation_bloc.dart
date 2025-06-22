import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecase/cancel_reservation.dart';
import '../../domain/usecase/get_field_schedule.dart';
import '../../domain/usecase/get_user_reservations.dart';
import '../../domain/usecase/make_reservation.dart';
import 'field_reservation_event.dart';
import 'field_reservation_state.dart';

class FieldReservationBloc extends Bloc<FieldReservationEvent, FieldReservationState> {
  final GetFieldSchedules getFieldSchedules;
  final MakeReservation makeReservation;
  final GetUserReservations getUserReservations;
  final CancelReservation cancelReservation;

  FieldReservationBloc({
    required this.getFieldSchedules,
    required this.makeReservation,
    required this.getUserReservations,
    required this.cancelReservation,
  }) : super(const FieldReservationInitial()) {
    on<LoadFieldSchedules>(_onLoadFieldSchedules);
    on<MakeFieldReservation>(_onMakeFieldReservation);
    on<LoadUserReservations>(_onLoadUserReservations);
    on<CancelFieldReservation>(_onCancelFieldReservation);
    on<ResetReservationState>(_onResetReservationState);
  }

  Future<void> _onLoadFieldSchedules(
    LoadFieldSchedules event,
    Emitter<FieldReservationState> emit,
  ) async {
    emit(const FieldSchedulesLoading());

    final result = await getFieldSchedules(event.fieldType);

    result.fold(
      (failure) => emit(FieldSchedulesError(message: "error")),
      (schedules) => emit(FieldSchedulesLoaded(schedules: schedules)),
    );
  }

  Future<void> _onMakeFieldReservation(
    MakeFieldReservation event,
    Emitter<FieldReservationState> emit,
  ) async {
    emit(const MakingReservation());

    final result = await makeReservation(event.request);

    result.fold(
      (failure) => emit(ReservationError(message: "error")),
      (reservation) => emit(ReservationMade(reservation: reservation)),
    );
  }

  Future<void> _onLoadUserReservations(
    LoadUserReservations event,
    Emitter<FieldReservationState> emit,
  ) async {
    emit(const UserReservationsLoading());

    final result = await getUserReservations(NoParams());

    result.fold(
      (failure) => emit(UserReservationsError(message: "error")),
      (reservations) => emit(UserReservationsLoaded(reservations: reservations)),
    );
  }

  Future<void> _onCancelFieldReservation(
    CancelFieldReservation event,
    Emitter<FieldReservationState> emit,
  ) async {
    emit(const CancellingReservation());

    final result = await cancelReservation(event.reservationId);

    result.fold(
      (failure) => emit(CancelReservationError(message: "error")),
      (success) => emit(ReservationCancelled(reservationId: event.reservationId)),
    );
  }

  void _onResetReservationState(
    ResetReservationState event,
    Emitter<FieldReservationState> emit,
  ) {
    emit(const FieldReservationInitial());
  }
}