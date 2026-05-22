import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

final selectedDay = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final appointmentsProvider = Provider<List<Appointment>>((ref) {
  return [
    Appointment(
      startTime: DateTime.now().add(const Duration(days: 0, hours: 3)),
      endTime: DateTime.now().add(const Duration(days: 0, hours: 4)),
      subject: 'Math Quiz',
      color: Colors.red,
    ),

    Appointment(
      startTime: DateTime.now().add(const Duration(days: 2, hours: 3)),
      endTime: DateTime.now().add(const Duration(days: 2, hours: 4)),
      subject: 'Science Activity',
      color: Colors.green,
    ),

    Appointment(
      startTime: DateTime.now().add(const Duration(days: 3, hours: 5)),
      endTime: DateTime.now().add(const Duration(days: 3, hours: 6)),
      subject: 'Reading Session',
      color: Colors.blue,
    ),
  ];
});

final selectedEventsProvider = Provider<List<Appointment>>((ref) {
  final selected = ref.watch(selectedDay);
  final appointments = ref.watch(appointmentsProvider);

  return appointments.where((event) {
    return event.startTime.year == selected.year &&
        event.startTime.month == selected.month &&
        event.startTime.day == selected.day;
  }).toList();
});

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
