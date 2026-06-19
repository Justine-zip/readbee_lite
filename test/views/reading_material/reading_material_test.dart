import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:readbee_lite/views/reading_material/reading_material_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_helper.dart';

void main() {
  testWidgets('showcase flag is saved after first launch', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      createTestWidget(child: const MobileReadingMaterialPage()),
    );

    await tester.pump();
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();

    expect(prefs.getBool('hasShownMaterialShowcase'), true);
  });

  testWidgets('opens StoryDialog when FAB is tapped', (tester) async {
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      createTestWidget(child: const MobileReadingMaterialPage()),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byType(StoryDialog), findsOneWidget);
  });
}
