import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:readbee_lite/models/grade_level.dart';
import 'package:readbee_lite/models/section.dart';
import 'package:readbee_lite/notifiers/record_notifier.dart';
import 'package:readbee_lite/providers/grade_level_provider.dart';
import 'package:readbee_lite/providers/record_provider.dart';
import 'package:readbee_lite/providers/section_provider.dart';

void main() {
  late ProviderContainer container;
  late RecordNotifier notifier;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        gradeLevelProvider.overrideWith(
          (ref) => [
            GradeLevel(
              gradeLevelId: 'g1',
              gradeNumber: 1,
              schoolId: '1',
              isActive: true,
            ),
            GradeLevel(
              gradeLevelId: 'g2',
              gradeNumber: 2,
              schoolId: '1',
              isActive: true,
            ),
          ],
        ),
        sectionProvider.overrideWith(
          (ref) => [
            Section(
              sectionId: 's1',
              sectionName: 'Rose',
              gradeLevelId: 'g1',
              schoolId: '1',
              yearId: '1',
            ),
            Section(
              sectionId: 's2',
              sectionName: 'Tulip',
              gradeLevelId: 'g1',
              schoolId: '1',
              yearId: '1',
            ),
            Section(
              sectionId: 's3',
              sectionName: 'Orchid',
              gradeLevelId: 'g2',
              schoolId: '1',
              yearId: '1',
            ),
          ],
        ),
      ],
    );

    notifier = container.read(recordProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('Initial State', () {
    test('starts with grade step', () {
      expect(notifier.state.currentStep, RecordStep.grade);
      expect(notifier.state.selectedGrade, null);
      expect(notifier.state.selectedSection, null);
      expect(notifier.state.selectedLanguage, null);
    });
  });

  group('selectGrade', () {
    test('updates grade and moves to section step', () {
      notifier.selectGrade('Grade 1', 'g1');

      expect(notifier.state.selectedGrade, 'Grade 1');
      expect(notifier.state.selectedGradeLevelId, 'g1');
      expect(notifier.state.currentStep, RecordStep.section);
    });
  });

  group('selectSection', () {
    test('updates section and moves to language step', () {
      notifier.selectSection('Rose', 's1');

      expect(notifier.state.selectedSection, 'Rose');
      expect(notifier.state.selectedSectionId, 's1');
      expect(notifier.state.currentStep, RecordStep.language);
    });
  });

  group('selectedLanguage', () {
    test('updates selected language', () {
      notifier.selectedLanguage('English');

      expect(notifier.state.selectedLanguage, 'English');
    });
  });

  group('goBack', () {
    test('language -> section', () {
      notifier.selectGrade('Grade 1', 'g1');
      notifier.selectSection('Rose', 's1');

      notifier.goBack();

      expect(notifier.state.currentStep, RecordStep.section);
    });

    test('section -> grade', () {
      notifier.selectGrade('Grade 1', 'g1');

      notifier.goBack();

      expect(notifier.state.currentStep, RecordStep.grade);
    });

    test('grade remains grade', () {
      notifier.goBack();

      expect(notifier.state.currentStep, RecordStep.grade);
    });
  });

  group('currentTitle', () {
    test('grade title', () {
      expect(notifier.currentTitle, 'Grade Level');
    });

    test('section title', () {
      notifier.selectGrade('Grade 1', 'g1');

      expect(notifier.currentTitle, 'Section (Grade 1)');
    });

    test('language title', () {
      notifier.selectGrade('Grade 1', 'g1');
      notifier.selectSection('Rose', 's1');

      expect(notifier.currentTitle, 'Language (Grade 1 • Rose)');
    });
  });

  group('currentOptions', () {
    test('returns grade options', () {
      expect(notifier.currentOptions, ['Grade 1', 'Grade 2']);
    });

    test('returns filtered sections for selected grade', () {
      notifier.selectGrade('Grade 1', 'g1');

      expect(notifier.currentOptions, ['Rose', 'Tulip']);
    });

    test('returns language options', () {
      notifier.selectGrade('Grade 1', 'g1');
      notifier.selectSection('Rose', 's1');

      expect(notifier.currentOptions, ['English', 'Filipino']);
    });
  });

  group('handleSelection', () {
    test('grade selection advances to section step', () {
      final result = notifier.handleSelection('Grade 1');

      expect(result, false);
      expect(notifier.state.currentStep, RecordStep.section);
      expect(notifier.state.selectedGrade, 'Grade 1');
      expect(notifier.state.selectedGradeLevelId, 'g1');
    });

    test('section selection advances to language step', () {
      notifier.handleSelection('Grade 1');

      final result = notifier.handleSelection('Rose');

      expect(result, false);
      expect(notifier.state.currentStep, RecordStep.language);
      expect(notifier.state.selectedSection, 'Rose');
      expect(notifier.state.selectedSectionId, 's1');
    });

    test('language selection returns true', () {
      notifier.handleSelection('Grade 1');
      notifier.handleSelection('Rose');

      final result = notifier.handleSelection('English');

      expect(result, true);
      expect(notifier.state.selectedLanguage, 'English');
    });
  });
}
