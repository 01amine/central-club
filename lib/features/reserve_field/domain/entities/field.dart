// field_type.dart
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
  
  String get fieldTypeTitle {
    switch (this) {
      case Field.soccer:
        return 'Réservation Terrain Central';
      case Field.padel:
        return 'Réservation Terrain Central';
    }
  }
}


class TimeSlot {
  final String time;
  final bool isSelected;
  
  TimeSlot({
    required this.time,
    this.isSelected = false,
  });
  
  TimeSlot copyWith({
    String? time,
    bool? isSelected,
  }) {
    return TimeSlot(
      time: time ?? this.time,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
List<TimeSlot> getTimeSlots() {
  return [
    TimeSlot(time: '8:30'),
    TimeSlot(time: '9:00'),
    TimeSlot(time: '9:30'),
    TimeSlot(time: '10:00'),
    TimeSlot(time: '10:30'),
    TimeSlot(time: '11:00'),
    TimeSlot(time: '11:30'),
    TimeSlot(time: '12:00'),
    TimeSlot(time: '12:30'),
    TimeSlot(time: '13:00'),
    TimeSlot(time: '13:30'),
    TimeSlot(time: '14:00'),
    TimeSlot(time: '14:30'),
    TimeSlot(time: '15:00'),
    TimeSlot(time: '15:30'),
    TimeSlot(time: '16:00'),
    TimeSlot(time: '16:30'),
    TimeSlot(time: '17:00'),
    TimeSlot(time: '17:30'),
    TimeSlot(time: '18:00'),
  ];
}