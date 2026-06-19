import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:readbee_lite/models/reading_material.dart';
import 'package:readbee_lite/models/story.dart';
import 'package:readbee_lite/notifiers/timer_notifier.dart';
import 'package:readbee_lite/pages/reading_material/digital_reading_page.dart';
import 'package:readbee_lite/providers/selected_material_provider.dart';
import 'package:readbee_lite/providers/story_provider.dart';
import 'package:readbee_lite/providers/timer_provider.dart';

import '../../helpers/test_helper.dart';

void main() {
  testWidgets('tap miscue button', (tester) async {
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      createTestWidget(
        overrides: [
          selectedMaterialProvider.overrideWith(
            (ref) => ReadingMaterial(
              materialId: '1',
              title: 'title',
              language: 'language',
              wordCount: 0,
              gradeLevelId: '1',
              storyId: '1',
              quizId: '1',
              status: 'status',
            ),
          ),

          timerProvider.overrideWith((ref) => FakeTimerNotifier(ref)),

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
        child: const MobileDigitalReadingPage(),
      ),
    );

    await tester.pump();

    final miscueFinder = find.text('Substitution');

    expect(miscueFinder, findsOneWidget);

    await tester.tap(miscueFinder);
    await tester.tap(miscueFinder);

    await tester.pump(const Duration(seconds: 2));

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });
}

class FakeTimerNotifier extends TimerNotifier {
  FakeTimerNotifier(super.ref);

  @override
  void start() {}

  @override
  void stop() {}

  @override
  void reset() {}
}
