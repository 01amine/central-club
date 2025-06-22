class Reservation {
  final String reservationId;
  final String fieldId;
  final String fieldName;
  final String fieldType;
  final String date;
  final String timeSlotId;
  final String startTime;
  final String endTime;
  final double price;
  final String status;
  final DateTime createdAt;

  const Reservation({
    required this.reservationId,
    required this.fieldId,
    required this.fieldName,
    required this.fieldType,
    required this.date,
    required this.timeSlotId,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.status,
    required this.createdAt,
  });
}