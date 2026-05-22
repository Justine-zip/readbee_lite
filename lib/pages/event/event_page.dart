import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/providers/calendar_event_provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventPage extends ConsumerWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedDay);
    final appointments = ref.watch(appointmentsProvider);
    final selectedEvents = ref.watch(selectedEventsProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 50, 24, 150),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: SfCalendar(
                view: CalendarView.month,

                dataSource: MeetingDataSource(appointments),

                monthViewSettings: const MonthViewSettings(
                  showAgenda: false,
                  appointmentDisplayMode: MonthAppointmentDisplayMode.none,
                ),

                monthCellBuilder: (
                  BuildContext context,
                  MonthCellDetails details,
                ) {
                  final appointments = details.appointments;
                  final today = DateTime.now();

                  final isToday =
                      details.date.year == today.year &&
                      details.date.month == today.month &&
                      details.date.day == today.day;

                  return Container(
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),

                      color:
                          isToday
                              ? Colors.amber
                              : (appointments.isNotEmpty
                                  ? (appointments.first as Appointment).color
                                  : Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainer),
                    ),

                    child: Stack(
                      children: [
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Text(
                            '${details.date.day}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color:
                                  appointments.isNotEmpty
                                      ? Colors.white
                                      : Colors.black54,
                            ),
                          ),
                        ),

                        if (appointments.isNotEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                (appointments.first as Appointment).subject,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },

                todayHighlightColor: Colors.amber,

                selectionDecoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),

                onSelectionChanged: (CalendarSelectionDetails details) {
                  final date = details.date;
                  if (date == null) return;

                  ref.read(selectedDay.notifier).state = date;
                },
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),

                child:
                    selectedEvents.isEmpty
                        ? const Center(
                          child: Text(
                            'No Event',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${selected.month}/${selected.day}/${selected.year}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 16),

                            Expanded(
                              child: ListView.builder(
                                itemCount: selectedEvents.length,
                                itemBuilder: (context, index) {
                                  final event = selectedEvents[index];

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: event.color,
                                      borderRadius: BorderRadius.circular(12),
                                    ),

                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event.subject,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),

                                        const SizedBox(height: 8),

                                        Text(
                                          '${event.startTime.hour.toString().padLeft(2, '0')}:${event.startTime.minute.toString().padLeft(2, '0')}'
                                          ' - '
                                          '${event.endTime.hour.toString().padLeft(2, '0')}:${event.endTime.minute.toString().padLeft(2, '0')}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
