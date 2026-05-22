import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

final selectedDay = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final appointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('assessment_schedules')
      .select('assessment_date, status');

  debugPrint('res: $response');

  final data = response as List<dynamic>? ?? [];

  return data.map((item) {
    final rawDate = item['assessment_date'];
    debugPrint('raw: $rawDate');

    final date = DateTime.parse(rawDate);

    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(hours: 1));

    return Appointment(
      startTime: start,
      endTime: end,
      subject: item['status'] ?? 'Assessment',
      color: Colors.green,
    );
  }).toList();
});

final selectedEventsProvider = Provider<List<Appointment>>((ref) {
  final selected = ref.watch(selectedDay);
  final appointmentsAsync = ref.watch(appointmentsProvider);

  return appointmentsAsync.when(
    data: (appointments) {
      return appointments.where((event) {
        return event.startTime.year == selected.year &&
            event.startTime.month == selected.month &&
            event.startTime.day == selected.day;
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) => appointments![index].startTime;

  @override
  DateTime getEndTime(int index) => appointments![index].endTime;

  @override
  String getSubject(int index) => appointments![index].subject;

  @override
  Color getColor(int index) => appointments![index].color;
}
