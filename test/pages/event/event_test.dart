import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:readbee_lite/pages/event/event_page.dart';
import 'package:readbee_lite/providers/calendar_event_provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../helpers/test_helper.dart';

void main() {
  testWidgets('display event calendar', (tester) async {
    await tester.pumpWidget(
      createTestWidget(
        overrides: [
          appointmentsProvider.overrideWith(
            (ref) => Future.value([
              Appointment(
                startTime: DateTime.now(),
                endTime: DateTime.now().add(const Duration(hours: 1)),
                subject: 'Test Event',
              ),
            ]),
          ),
        ],
        child: const MobileEventPage(),
      ),
    );

    await tester.pump();

    expect(find.byType(SfCalendar), findsOneWidget);
  });

  testWidgets('shows loading indicator', (tester) async {
    final completer = Completer<List<Appointment>>();

    await tester.pumpWidget(
      createTestWidget(
        overrides: [
          appointmentsProvider.overrideWith((ref) => completer.future),
        ],
        child: const MobileEventPage(),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
