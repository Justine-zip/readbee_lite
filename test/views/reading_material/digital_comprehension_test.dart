import 'package:flutter_test/flutter_test.dart';
import 'package:readbee_lite/models/choice_item.dart';
import 'package:readbee_lite/models/quiz_question.dart';
import 'package:readbee_lite/models/reading_material.dart';
import 'package:readbee_lite/viewmodels/providers/quiz_question_provider.dart';
import 'package:readbee_lite/viewmodels/providers/selected_material_provider.dart';
import 'package:readbee_lite/views/reading_material/digitral_comprehension_page.dart';

import '../../helpers/test_helper.dart';

void main() {
  testWidgets('load test questions and choices', (tester) async {
    await tester.pumpWidget(
      createTestWidget(
        overrides: [
          selectedMaterialProvider.overrideWith(
            (ref) => ReadingMaterial(
              materialId: '1',
              title: 'Sample Title',
              language: 'English',
              wordCount: 10,
              gradeLevelId: '1',
              storyId: '1',
              quizId: '1',
              status: 'active',
            ),
          ),

          quizQuestionProvider.overrideWith(
            (ref) => [
              QuizQuestion(
                questionId: '1',
                quizId: '1',
                questionText: 'sample',
                choices: [ChoiceItem(letter: 'a', choice: 'sample choice')],
                correctAnswer: 0,
                points: 1,
                questionOrder: 0,
              ),
            ],
          ),
        ],
        child: const MobileDigitralComprehensionPage(),
      ),
    );

    await tester.pump();

    expect(find.text('sample'), findsOneWidget);
    expect(find.text('sample choice'), findsOneWidget);
  });
}
