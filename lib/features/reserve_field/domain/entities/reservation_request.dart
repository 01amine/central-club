class ReservationRequest {
  final String fieldId;
  final String date;
  final String timeSlotId;

  const ReservationRequest({
    required this.fieldId,
    required this.date,
    required this.timeSlotId,
  });
}