import 'package:flutter_test/flutter_test.dart';
import 'package:readbee_lite/components/reading_material_builder.dart';
import 'package:readbee_lite/models/reading_material.dart';

import '../helpers/test_helper.dart';

void main() {
  testWidgets('displays reading material title when material is provided', (
    tester,
  ) async {
    final List<ReadingMaterial> material = [
      ReadingMaterial(
        materialId: '1',
        title: 'Test Story',
        language: 'English',
        wordCount: 94,
        gradeLevelId: '1',
        storyId: '1',
        quizId: '1',
        status: 'status',
      ),
    ];

    await tester.pumpWidget(
      createTestWidget(child: ReadingMaterialBuilder(material: material)),
    );

    await tester.pump();

    expect(find.text('Test Story'), findsOneWidget);
  });
}
