import 'available_date.dart';

enum Field {
  soccer,
  padel,
}

extension FieldExtension on Field {
  String get displayName {
    switch (this) {
      case Field.soccer:
        return 'CENTRAL SOCCER';
      case Field.padel:
        return 'CENTRAL PADEL';
    }
  }
}

class FieldSchedule {
  final String fieldId;
  final String fieldName;
  final String fieldType;
  final String location;
  final List<AvailableDate> availableDates;

  const FieldSchedule({
    required this.fieldId,
    required this.fieldName,
    required this.fieldType,
    required this.location,
    required this.availableDates,
  });
}
