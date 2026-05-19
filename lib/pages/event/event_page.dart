import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/providers/calendar_event_provider.dart';
import 'package:table_calendar/table_calendar.dart';

class EventPage extends ConsumerStatefulWidget {
  const EventPage({super.key});

  @override
  ConsumerState<EventPage> createState() => _EventPageState();
}

class _EventPageState extends ConsumerState<EventPage> {
  @override
  Widget build(BuildContext context) {
    final daySelector = ref.watch(selectedDay);

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              width: MediaQuery.of(context).size.width * .8,
              child: TableCalendar(
                calendarStyle: CalendarStyle(
                  todayTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),

                  defaultTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),

                  // NORMAL DAYS
                  defaultDecoration: BoxDecoration(
                    color: Colors.amber[300],
                    borderRadius: BorderRadius.circular(8),
                  ),

                  // TODAY
                  todayDecoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8),
                  ),

                  // SELECTED DAY
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),

                  selectedTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                selectedDayPredicate: (day) {
                  return isSameDay(daySelector, day);
                },

                onDaySelected: (pickedDay, focusedDay) {
                  ref.read(selectedDay.notifier).state = pickedDay;
                },

                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: daySelector,
              ),
            ),
          ),

          const Center(
            child: Text(
              'E V E N T - X',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
