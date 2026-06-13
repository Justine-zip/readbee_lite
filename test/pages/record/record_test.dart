import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:readbee_lite/components/record_list_builder.dart';
import 'package:readbee_lite/models/grade_level.dart';
import 'package:readbee_lite/pages/record/record_page.dart';
import 'package:readbee_lite/providers/completion_rate_provider.dart';
import 'package:readbee_lite/providers/grade_level_provider.dart';
import 'package:readbee_lite/providers/section_provider.dart';

import '../../helpers/test_helper.dart';

void main() {
  testWidgets('shows current record title', (tester) async {
    await tester.pumpWidget(createTestWidget(child: const MobileRecordPage()));

    await tester.pumpAndSettle();

    expect(find.text('Grade Level'), findsOneWidget);
  });

  testWidgets('calls onTap when card is tapped', (tester) async {
    String? tappedValue;

    await tester.pumpWidget(
      createTestWidget(
        overrides: [
          sectionProvider.overrideWith((ref) async => []),
          gradeRateProvider.overrideWith((ref) async => {'g1': 0.5}),
          sectionRateProvider.overrideWith((ref) async => <String, double>{}),
          gradeLevelProvider.overrideWith(
            (ref) async => [
              GradeLevel(
                isActive: true,
                schoolId: '1',
                gradeLevelId: 'g1',
                gradeNumber: 1,
              ),
            ],
          ),
        ],
        child: Column(
          children: [
            RecordListBuilder(
              itemCount: 1,
              title: const ['Grade 1'],
              onTap: (value) => tappedValue = value,
            ),
          ],
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Grade 1'));

    expect(tappedValue, 'Grade 1');
  });
}
