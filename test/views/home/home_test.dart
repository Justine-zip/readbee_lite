import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:readbee_lite/models/profile.dart';
import 'package:readbee_lite/viewmodels/providers/analytics_provider.dart';
import 'package:readbee_lite/viewmodels/providers/profile_provider.dart';
import 'package:readbee_lite/views/home/home_page.dart';
import 'package:shimmer/shimmer.dart';

import '../../helpers/test_helper.dart';

void main() {
  testWidgets('Home page displays profile and analytics data', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      createTestWidget(
        overrides: [
          profileProvider.overrideWith(
            (ref) => Future.value(
              Profile(
                id: '1',
                fullName: 'Juan Dela Cruz',
                email: 'juandelacruz@gmail.com',
              ),
            ),
          ),

          readingSpeedProvider.overrideWith(
            (ref) => Future.value([
              'slow',
              'fast',
              'average',
              'struggling',
              'non-reader',
            ]),
          ),

          readingLevelProvider.overrideWith(
            (ref) =>
                Future.value(['frustration', 'instructional', 'independent']),
          ),

          comprehensionLevelProvider.overrideWith(
            (ref) =>
                Future.value(['frustration', 'instructional', 'independent']),
          ),
        ],
        child: const MobileHomePage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Juan Dela Cruz'), findsOneWidget);

    expect(find.text('Reading Speed'), findsOneWidget);

    expect(find.text('Reading Level'), findsOneWidget);

    expect(find.text('Comprehension Level'), findsOneWidget);
  });

  testWidgets('Shows loading state while waiting for data', (tester) async {
    await tester.pumpWidget(
      createTestWidget(
        overrides: [
          profileProvider.overrideWith(
            (ref) => Future.delayed(
              const Duration(seconds: 1),
              () => Profile(
                id: '99',
                fullName: 'test user',
                email: 'testuser@gmail.com',
              ),
            ),
          ),
        ],
        child: const MobileHomePage(),
      ),
    );

    expect(find.byType(Shimmer), findsWidgets);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  });

  testWidgets('test home filter', (tester) async {
    await tester.pumpWidget(
      createTestWidget(
        overrides: [
          languagesProvider.overrideWith(
            (ref) => Future.value(['English', 'Filipino']),
          ),

          schoolYearsProvider.overrideWith(
            (ref) => Future.value([
              {
                'year_id': '1',
                'start_date': '2024-06-01',
                'end_date': '2025-03-31',
              },
            ]),
          ),

          quartersProvider.overrideWith(
            (ref) => Future.value([
              {'quarter_id': 1, 'quarter_number': 'Q1'},
            ]),
          ),

          gradeLevelsProvider.overrideWith(
            (ref) => Future.value([
              {'grade_level_id': 'g1', 'grade_number': 1},
            ]),
          ),
        ],
        child: const AnalyticsFilterDialog(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Analytics Filters'), findsOneWidget);
    expect(find.text('Clear'), findsOneWidget);
    expect(find.text('Apply'), findsOneWidget);

    expect(find.byType(DropdownButtonFormField<String>), findsNWidgets(3));
    expect(find.byType(DropdownButtonFormField<int>), findsOneWidget);
  });
}
