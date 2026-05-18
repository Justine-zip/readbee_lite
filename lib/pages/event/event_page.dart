import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .8,
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
            ),
          ),
          Center(
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
