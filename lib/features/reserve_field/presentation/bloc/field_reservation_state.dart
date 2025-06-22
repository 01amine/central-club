import 'package:equatable/equatable.dart';
import '../../domain/entities/field_schedule.dart';
import '../../domain/entities/reservation.dart';

abstract class FieldReservationState extends Equatable {
  const FieldReservationState();

  @override
  List<Object?> get props => [];
}

class FieldReservationInitial extends FieldReservationState {
  const FieldReservationInitial();
}

// Field Schedules States
class FieldSchedulesLoading extends FieldReservationState {
  const FieldSchedulesLoading();
}

class FieldSchedulesLoaded extends FieldReservationState {
  final List<FieldSchedule> schedules;

  const FieldSchedulesLoaded({required this.schedules});

  @override
  List<Object?> get props => [schedules];
}

class FieldSchedulesError extends FieldReservationState {
  final String message;

  const FieldSchedulesError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Make Reservation States
class MakingReservation extends FieldReservationState {
  const MakingReservation();
}

class ReservationMade extends FieldReservationState {
  final Reservation reservation;

  const ReservationMade({required this.reservation});

  @override
  List<Object?> get props => [reservation];
}

class ReservationError extends FieldReservationState {
  final String message;

  const ReservationError({required this.message});

  @override
  List<Object?> get props => [message];
}

// User Reservations States
class UserReservationsLoading extends FieldReservationState {
  const UserReservationsLoading();
}

class UserReservationsLoaded extends FieldReservationState {
  final List<Reservation> reservations;

  const UserReservationsLoaded({required this.reservations});

  @override
  List<Object?> get props => [reservations];
}

class UserReservationsError extends FieldReservationState {
  final String message;

  const UserReservationsError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Cancel Reservation States
class CancellingReservation extends FieldReservationState {
  const CancellingReservation();
}

class ReservationCancelled extends FieldReservationState {
  final String reservationId;

  const ReservationCancelled({required this.reservationId});

  @override
  List<Object?> get props => [reservationId];
}

class CancelReservationError extends FieldReservationState {
  final String message;

  const CancelReservationError({required this.message});

  @override
  List<Object?> get props => [message];
}