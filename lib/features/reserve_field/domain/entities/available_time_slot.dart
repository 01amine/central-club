class AvailableTimeSlot {
  final String timeSlotId;
  final String startTime;
  final String endTime;
  final bool isAvailable;
  final double price;

  const AvailableTimeSlot({
    required this.timeSlotId,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
    required this.price,
  });
}