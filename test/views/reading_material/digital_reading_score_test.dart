import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:readbee_lite/models/miscue.dart';
import 'package:readbee_lite/models/reading_material.dart';
import 'package:readbee_lite/models/story.dart';
import 'package:readbee_lite/notifiers/miscue_notifier.dart';
import 'package:readbee_lite/pages/reading_material/digital_reading_score_page.dart';
import 'package:readbee_lite/providers/miscue_content_provider.dart';
import 'package:readbee_lite/providers/miscue_provider.dart';
import 'package:readbee_lite/providers/selected_material_provider.dart';
import 'package:readbee_lite/providers/story_provider.dart';

import '../../helpers/test_helper.dart';

void main() {
  testWidgets('renders Digital Reading Score page', (tester) async {
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

          miscueProvider.overrideWith(FakeMiscueNotifier.new),

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

          miscueContentProvider.overrideWith((ref) => <String, List<int>>{}),
        ],
        child: const MobileDigitalReadingScorePage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Digital Reading Score'), findsOneWidget);
    expect(find.text('Summary of Miscue'), findsOneWidget);
    expect(find.text('Proceed'), findsOneWidget);
  });
}

class FakeMiscueNotifier extends MiscueNotifier {
  @override
  List<Miscue> build() {
    return [
      Miscue(name: 'Omission', count: 0, color: Colors.purple),
      Miscue(name: 'Repetition', count: 0, color: Colors.grey),
      Miscue(name: 'Substitution', count: 0, color: Colors.red),
      Miscue(name: 'Reversal', count: 0, color: Colors.blue),
      Miscue(name: 'Transposition', count: 0, color: Colors.pink),
      Miscue(name: 'Insertion', count: 0, color: Colors.yellow),
      Miscue(name: 'Mispronunciation', count: 0, color: Colors.orange),
      Miscue(name: 'Correct', count: 0, color: Colors.green),
    ];
  }
}
