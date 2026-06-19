import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/viewmodels/providers/calendar_event_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MobileEventPage extends ConsumerStatefulWidget {
  const MobileEventPage({super.key});

  @override
  ConsumerState<MobileEventPage> createState() => _MobileEventPageState();
}

class _MobileEventPageState extends ConsumerState<MobileEventPage> {
  final GlobalKey calendarKey = GlobalKey();
  final GlobalKey eventKey = GlobalKey();

  Future<void> showShowcase(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    final hasShown = prefs.getBool('hasShownEventShowcase') ?? false;

    if (!hasShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([calendarKey, eventKey]);
      });

      await prefs.setBool('hasShownEventShowcase', true);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showShowcase(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(selectedDay);
    final appointmentsAsync = ref.watch(appointmentsProvider);
    final selectedEvents = ref.watch(selectedEventsProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 50, 24, 150),
        child: Column(
          children: [
            /// ================= CALENDAR =================
            Expanded(
              flex: 3,
              child: appointmentsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (appointments) {
                  return Showcase(
                    key: calendarKey,
                    title: 'Calendar',
                    description: 'Select a date to view events.',
                    titleTextStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    descTextStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    child: SfCalendar(
                      view: CalendarView.month,

                      headerStyle: CalendarHeaderStyle(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      dataSource: MeetingDataSource(appointments),

                      monthViewSettings: const MonthViewSettings(
                        showAgenda: false,
                        appointmentDisplayMode:
                            MonthAppointmentDisplayMode.none,
                      ),

                      monthCellBuilder: (context, details) {
                        final appts = details.appointments;
                        final today = DateTime.now();

                        // debugPrint('details: $details');

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
                                    : (appts.isNotEmpty
                                        ? (appts.first as Appointment).color
                                        : Theme.of(
                                          context,
                                        ).colorScheme.primaryContainer),
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
                                        appts.isNotEmpty
                                            ? Colors.white
                                            : Colors.black54,
                                  ),
                                ),
                              ),
                              if (appts.isNotEmpty)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.schedule_rounded,
                                      size: 16,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },

                      todayHighlightColor: Colors.amber,

                      selectionDecoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),

                      onSelectionChanged: (details) {
                        final date = details.date;
                        if (date == null) return;

                        ref.read(selectedDay.notifier).state = date;
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            /// ================= SIDE PANEL =================
            Expanded(
              flex: 2,
              child: Showcase(
                key: eventKey,
                title: 'Event Details',
                description: 'View details of the selected event.',
                titleTextStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                descTextStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child:
                      selectedEvents.isEmpty
                          ? const Center(
                            child: Text(
                              'No Event',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          )
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${selected.month}/${selected.day}/${selected.year}',
                                style: const TextStyle(
                                  fontSize: 16,
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
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            '7:00 AM'
                                            ' - '
                                            '4:00 PM',
                                            style: TextStyle(
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
            ),
          ],
        ),
      ),
    );
  }
}

class TabletEventPage extends ConsumerStatefulWidget {
  const TabletEventPage({super.key});

  @override
  ConsumerState<TabletEventPage> createState() => _TabletEventPageState();
}

class _TabletEventPageState extends ConsumerState<TabletEventPage> {
  final GlobalKey calendarKey = GlobalKey();
  final GlobalKey eventKey = GlobalKey();

  Future<void> showShowcase(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    final hasShown = prefs.getBool('hasShownEventShowcase') ?? false;

    if (!hasShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([calendarKey, eventKey]);
      });

      await prefs.setBool('hasShownEventShowcase', true);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showShowcase(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(selectedDay);
    final appointmentsAsync = ref.watch(appointmentsProvider);
    final selectedEvents = ref.watch(selectedEventsProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 50, 24, 150),
        child: Row(
          children: [
            /// ================= CALENDAR =================
            Expanded(
              flex: 3,
              child: appointmentsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (appointments) {
                  return Showcase(
                    key: calendarKey,
                    title: 'Calendar',
                    description: 'Select a date to view events.',
                    child: SfCalendar(
                      view: CalendarView.month,

                      headerStyle: CalendarHeaderStyle(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      dataSource: MeetingDataSource(appointments),

                      monthViewSettings: const MonthViewSettings(
                        showAgenda: false,
                        appointmentDisplayMode:
                            MonthAppointmentDisplayMode.none,
                      ),

                      monthCellBuilder: (context, details) {
                        final appts = details.appointments;
                        final today = DateTime.now();

                        // debugPrint('details: $details');

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
                                    : (appts.isNotEmpty
                                        ? (appts.first as Appointment).color
                                        : Theme.of(
                                          context,
                                        ).colorScheme.primaryContainer),
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
                                        appts.isNotEmpty
                                            ? Colors.white
                                            : Colors.black54,
                                  ),
                                ),
                              ),
                              if (appts.isNotEmpty)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      (appts.first as Appointment).subject,
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
                        color: Colors.blue.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),

                      onSelectionChanged: (details) {
                        final date = details.date;
                        if (date == null) return;

                        ref.read(selectedDay.notifier).state = date;
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 8),

            /// ================= SIDE PANEL =================
            Expanded(
              flex: 1,
              child: Showcase(
                key: eventKey,
                title: 'Event Details',
                description: 'View details of the selected event.',
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.primaryContainer,
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
            ),
          ],
        ),
      ),
    );
  }
}
