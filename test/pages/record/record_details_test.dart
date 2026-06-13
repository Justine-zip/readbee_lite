import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:readbee_lite/models/assessment_record.dart';
import 'package:readbee_lite/models/quiz_question.dart';
import 'package:readbee_lite/models/reading_material.dart';
import 'package:readbee_lite/models/student.dart';
import 'package:readbee_lite/notifiers/record_notifier.dart';
import 'package:readbee_lite/pages/record/record_details_page.dart';
import 'package:readbee_lite/providers/assessment_record_provider.dart';
import 'package:readbee_lite/providers/quiz_question_provider.dart';
import 'package:readbee_lite/providers/record_provider.dart';
import 'package:readbee_lite/providers/selected_material_provider.dart';
import 'package:readbee_lite/providers/story_provider.dart';

import '../../helpers/test_helper.dart';

void main() {
  testWidgets('shows loading indicator while assessment loads', (tester) async {
    final completer = Completer<List<AssessmentRecord>>();

    await tester.pumpWidget(
      createTestWidget(
        overrides: [
          assessmentRecordProvider.overrideWith((ref) => completer.future),
        ],
        child: const MobileRecordDetailsPage(),
      ),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('shows no reading score when assessment list is empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      createTestWidget(
        overrides: [
          assessmentRecordProvider.overrideWith((ref) => <AssessmentRecord>[]),
        ],
        child: const MobileRecordDetailsPage(),
      ),
    );
    await tester.pump();

    expect(find.text('No reading score'), findsOneWidget);
  });

  testWidgets('shows no story found when story list is empty', (tester) async {
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

          recordProvider.overrideWith(() => TestRecordNotifier()),

          assessmentRecordProvider.overrideWith(
            (ref) => [
              AssessmentRecord(
                assessmentRecordId: '1',
                pupilId: '1',
                evaluatorId: '1',
                materialId: '1',
                scheduleId: '1',
                yearId: '1',
                quarterId: '1',
                assignmentId: '1',
                assessmentMethod: '',
                assessmentType: 'assessmentType',
                readingScore: {},
                comprehensionScore: {},
                totalScore: 0,
                readingLevel: '',
                status: '',
                miscueContent: {},
              ),
            ],
          ),
          storyProvider.overrideWith((ref) async => null),
        ],
        child: const MobileRecordDetailsPage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No story found'), findsOneWidget);
  });

  testWidgets('shows no questions found when question list is empty', (
    tester,
  ) async {
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

          recordProvider.overrideWith(() => TestRecordNotifier()),

          assessmentRecordProvider.overrideWith(
            (ref) => [
              AssessmentRecord(
                assessmentRecordId: '1',
                pupilId: '1',
                evaluatorId: '1',
                materialId: '1',
                scheduleId: '1',
                yearId: '1',
                quarterId: '1',
                assignmentId: '1',
                assessmentMethod: '',
                assessmentType: 'assessmentType',
                readingScore: {},
                comprehensionScore: {},
                totalScore: 0,
                readingLevel: '',
                status: '',
                miscueContent: {},
              ),
            ],
          ),
          quizQuestionProvider.overrideWith((ref) async => <QuizQuestion>[]),
        ],
        child: const MobileRecordDetailsPage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No questions found'), findsOneWidget);
  });
}

class TestRecordNotifier extends RecordNotifier {
  @override
  RecordState build() {
    return RecordState(
      selectedStudent: Student(
        name: 'name',
        lrn: 'lrn',
        sectionId: '1',
        studentId: '1',
      ),
    );
  }
}
