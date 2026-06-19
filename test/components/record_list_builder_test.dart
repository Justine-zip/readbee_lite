import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:readbee_lite/components/record_list_builder.dart';
import 'package:readbee_lite/models/grade_level.dart';
import 'package:readbee_lite/models/section.dart';
import 'package:readbee_lite/providers/completion_rate_provider.dart';
import 'package:readbee_lite/providers/grade_level_provider.dart';
import 'package:readbee_lite/providers/section_provider.dart';

import '../helpers/test_helper.dart';

void main() {
  testWidgets('renders record titles', (tester) async {
    await tester.pumpWidget(
      createTestWidget(
        overrides: [
          sectionProvider.overrideWith(
            (ref) => [
              Section(
                sectionId: '1',
                schoolId: '1',
                yearId: '1',
                gradeLevelId: '1',
              ),
            ],
          ),
          gradeRateProvider.overrideWith((ref) => {}),
          sectionRateProvider.overrideWith((ref) => {}),
          gradeLevelProvider.overrideWith(
            (ref) => [
              GradeLevel(
                gradeLevelId: '1',
                schoolId: '1',
                gradeNumber: 1,
                isActive: true,
              ),
            ],
          ),
        ],
        child: Column(
          children: [
            RecordListBuilder(
              itemCount: 2,
              title: const ['Grade 1', 'Grade 2'],
              onTap: (index) => null,
            ),
          ],
        ),
      ),
    );

    expect(find.text('Grade 1'), findsOneWidget);
    expect(find.text('Grade 2'), findsOneWidget);
  });

  testWidgets('shows loading indicator', (tester) async {
    final completer = Completer<List<Section>>();

    await tester.pumpWidget(
      createTestWidget(
        overrides: [
          sectionProvider.overrideWith((ref) => completer.future),
          gradeRateProvider.overrideWith((ref) => {}),
          sectionRateProvider.overrideWith((ref) => {}),
          gradeLevelProvider.overrideWith(
            (ref) => [
              GradeLevel(
                gradeLevelId: '1',
                schoolId: '1',
                gradeNumber: 1,
                isActive: true,
              ),
            ],
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                RecordListBuilder(itemCount: 0, title: [], onTap: null),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
