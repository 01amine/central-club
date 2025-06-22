import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/reservation.dart';
import '../../domain/usecase/cancel_reservation.dart';
import '../../domain/usecase/get_field_schedule.dart';
import '../../domain/usecase/get_user_reservations.dart';
import '../../domain/usecase/make_reservation.dart';
import '../../domain/entities/field_schedule.dart';
import '../../domain/entities/available_date.dart';
import '../../domain/entities/available_time_slot.dart';
import 'field_reservation_event.dart';
import 'field_reservation_state.dart';

class FieldReservationBloc
    extends Bloc<FieldReservationEvent, FieldReservationState> {
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

    // final result = await getFieldSchedules(event.fieldType);
    //
    // result.fold(
    //   (failure) => emit(FieldSchedulesError(message: "error")),
    //   (schedules) => emit(FieldSchedulesLoaded(schedules: schedules)),
    // );

    await Future.delayed(const Duration(seconds: 1));

    final fakeFieldSchedules = [
      FieldSchedule(
        fieldId: 'field_1_soccer',
        fieldName: 'Terrain de Foot 1',
        fieldType: 'soccer',
        location: 'Centre Sportif A',
        availableDates: [
          AvailableDate(
            date: '2025-07-20',
            dayName: 'Dim',
            day: '20',
            month: 'Juil',
            availableTimeSlots: [
              AvailableTimeSlot(
                  timeSlotId: 'ts1',
                  startTime: '09:00',
                  endTime: '10:00',
                  isAvailable: true,
                  price: 50.0),
              AvailableTimeSlot(
                  timeSlotId: 'ts2',
                  startTime: '10:00',
                  endTime: '11:00',
                  isAvailable: false,
                  price: 50.0),
              AvailableTimeSlot(
                  timeSlotId: 'ts3',
                  startTime: '11:00',
                  endTime: '12:00',
                  isAvailable: true,
                  price: 50.0),
            ],
          ),
          AvailableDate(
            date: '2025-07-21',
            dayName: 'Lun',
            day: '21',
            month: 'Juil',
            availableTimeSlots: [
              AvailableTimeSlot(
                  timeSlotId: 'ts4',
                  startTime: '14:00',
                  endTime: '15:00',
                  isAvailable: true,
                  price: 60.0),
              AvailableTimeSlot(
                  timeSlotId: 'ts5',
                  startTime: '15:00',
                  endTime: '16:00',
                  isAvailable: true,
                  price: 60.0),
            ],
          ),
        ],
      ),
      FieldSchedule(
        fieldId: 'field_2_soccer',
        fieldName: 'Terrain de Foot 2',
        fieldType: 'soccer',
        location: 'Centre Sportif B',
        availableDates: [
          AvailableDate(
            date: '2025-07-20',
            dayName: 'Dim',
            day: '20',
            month: 'Juil',
            availableTimeSlots: [
              AvailableTimeSlot(
                  timeSlotId: 'ts6',
                  startTime: '10:00',
                  endTime: '11:00',
                  isAvailable: true,
                  price: 55.0),
              AvailableTimeSlot(
                  timeSlotId: 'ts7',
                  startTime: '11:00',
                  endTime: '12:00',
                  isAvailable: false,
                  price: 55.0),
            ],
          ),
        ],
      ),
      FieldSchedule(
        fieldId: 'field_1_padel',
        fieldName: 'Terrain de Padel 1',
        fieldType: 'padel',
        location: 'Club de Padel X',
        availableDates: [
          AvailableDate(
            date: '2025-07-22',
            dayName: 'Mar',
            day: '22',
            month: 'Juil',
            availableTimeSlots: [
              AvailableTimeSlot(
                  timeSlotId: 'ts8',
                  startTime: '17:00',
                  endTime: '18:00',
                  isAvailable: true,
                  price: 40.0),
              AvailableTimeSlot(
                  timeSlotId: 'ts9',
                  startTime: '18:00',
                  endTime: '19:00',
                  isAvailable: true,
                  price: 40.0),
            ],
          ),
        ],
      ),
    ];

    final filteredSchedules = fakeFieldSchedules
        .where((schedule) => schedule.fieldType == event.fieldType)
        .toList();

    emit(FieldSchedulesLoaded(schedules: filteredSchedules));
  }

  Future<void> _onMakeFieldReservation(
    MakeFieldReservation event,
    Emitter<FieldReservationState> emit,
  ) async {
    emit(const MakingReservation());

    await Future.delayed(const Duration(seconds: 1));

    final fakeReservation = Reservation(
      reservationId: 'res_fake_123',
      fieldId: event.request.fieldId,
      fieldName: 'Fake Field Name',
      fieldType: 'fakeType',
      date: event.request.date,
      timeSlotId: event.request.timeSlotId,
      startTime: 'Fake Start Time',
      endTime: 'Fake End Time',
      price: 0.0,
      status: 'confirmed',
      createdAt: DateTime.now(),
    );

    emit(ReservationMade(reservation: fakeReservation));
  }

  Future<void> _onLoadUserReservations(
    LoadUserReservations event,
    Emitter<FieldReservationState> emit,
  ) async {
    emit(const UserReservationsLoading());

    final result = await getUserReservations(NoParams());

    result.fold(
      (failure) => emit(UserReservationsError(message: "error")),
      (reservations) =>
          emit(UserReservationsLoaded(reservations: reservations)),
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
      (success) =>
          emit(ReservationCancelled(reservationId: event.reservationId)),
    );
  }

  void _onResetReservationState(
    ResetReservationState event,
    Emitter<FieldReservationState> emit,
  ) {
    emit(const FieldReservationInitial());
  }
}
