import 'available_time_slot.dart';

class AvailableDate {
  final String date;
  final String dayName;
  final String day;
  final String month;
  final List<AvailableTimeSlot> availableTimeSlots;

  const AvailableDate({
    required this.date,
    required this.dayName,
    required this.day,
    required this.month,
    required this.availableTimeSlots,
  });
}