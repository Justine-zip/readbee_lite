import 'package:flutter_test/flutter_test.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/models/story.dart';
import 'package:readbee_lite/pages/reading_material/reading_material_details_page.dart';
import 'package:readbee_lite/providers/calendar_event_provider.dart';
import 'package:readbee_lite/providers/story_provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../helpers/test_helper.dart';

void main() {
  testWidgets('displays story details when story data is available', (
    tester,
  ) async {
    await tester.pumpWidget(
      createTestWidget(
        overrides: [
          storyProvider.overrideWith(
            (ref) => Story(
              storyId: 'storyId',
              title: 'Test Story',
              content: 'content',
              wordCount: 53,
              language: 'English',
              gradeLevelId: '1',
              status: 'status',
              createdBy: 'createdBy',
            ),
          ),
        ],
        child: const MobileReadingMaterialDetailsPage(),
      ),
    );

    await tester.pump();

    expect(find.text('Reading Material'), findsOneWidget);
    expect(find.text('Test Story'), findsNWidgets(2));
    expect(find.text('content'), findsOneWidget);
    expect(find.text('Bilang ng mga salita: 53'), findsOneWidget);
    expect(find.text('Language: English'), findsOneWidget);
    expect(find.text('Proceed'), findsOneWidget);
  });

  testWidgets('shows evaluation dialog when appointment exists today', (
    tester,
  ) async {
    final today = DateTime.now();

    await tester.pumpWidget(
      createTestWidget(
        overrides: [
          storyProvider.overrideWith(
            (ref) => Story(
              storyId: 'storyId',
              title: 'Test Story',
              content: 'content',
              wordCount: 53,
              language: 'English',
              gradeLevelId: '1',
              status: 'status',
              createdBy: 'createdBy',
            ),
          ),
          appointmentsProvider.overrideWith(
            (ref) => Future.value([
              Appointment(
                startTime: today,
                endTime: DateTime.now().add(const Duration(hours: 2)),
              ),
            ]),
          ),
        ],
        child: const MobileReadingMaterialDetailsPage(),
      ),
    );

    await tester.tap(find.byType(CustomButton));
    await tester.pumpAndSettle();

    expect(find.text('Proceed'), findsOneWidget);
  });
}
