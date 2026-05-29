import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/student.dart';
import 'package:readbee_lite/providers/grade_level_provider.dart';
import 'package:readbee_lite/providers/section_provider.dart';

enum RecordStep { grade, section, language }

class RecordState {
  final RecordStep currentStep;
  final String? selectedGrade;
  final String? selectedGradeLevelId;
  final String? selectedSection;
  final String? selectedSectionId;
  final String? selectedLanguage;
  final Student? selectedStudent;

  const RecordState({
    this.currentStep = RecordStep.grade,
    this.selectedGrade,
    this.selectedGradeLevelId,
    this.selectedSection,
    this.selectedSectionId,
    this.selectedLanguage,
    this.selectedStudent,
  });

  RecordState copyWith({
    RecordStep? currentStep,
    String? selectedGrade,
    String? selectedGradeLevelId,
    String? selectedSection,
    String? selectedSectionId,
    String? selectedLanguage,
    Student? selectedStudent,
  }) {
    return RecordState(
      currentStep: currentStep ?? this.currentStep,
      selectedGrade: selectedGrade ?? this.selectedGrade,
      selectedGradeLevelId: selectedGradeLevelId ?? this.selectedGradeLevelId,
      selectedSection: selectedSection ?? this.selectedSection,
      selectedSectionId: selectedSectionId ?? this.selectedSectionId,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedStudent: selectedStudent ?? this.selectedStudent,
    );
  }
}

class RecordNotifier extends Notifier<RecordState> {
  @override
  RecordState build() {
    return const RecordState();
  }

  void selectGrade(String grade, String gradeLevelId) {
    state = state.copyWith(
      selectedGrade: grade,
      selectedGradeLevelId: gradeLevelId,
      currentStep: RecordStep.section,
    );
  }

  void selectSection(String section, String sectionId) {
    state = state.copyWith(
      selectedSection: section,
      selectedSectionId: sectionId,
      currentStep: RecordStep.language,
    );
  }

  void selectedLanguage(String language) {
    state = state.copyWith(selectedLanguage: language);
  }

  void selectedStudent(Student student) {
    state = state.copyWith(selectedStudent: student);
  }

  void goBack() {
    if (state.currentStep == RecordStep.language) {
      state = state.copyWith(currentStep: RecordStep.section);
    } else if (state.currentStep == RecordStep.section) {
      state = state.copyWith(currentStep: RecordStep.grade);
    }
  }

  bool handleSelection(String value) {
    if (state.currentStep == RecordStep.grade) {
      final grades = ref.read(gradeLevelProvider).value ?? [];

      final selectedGradeData = grades.firstWhere(
        (g) => 'Grade ${g.gradeNumber}' == value,
      );

      selectGrade(value, selectedGradeData.gradeLevelId);

      return false;
    }

    if (state.currentStep == RecordStep.section) {
      final section = ref.read(sectionProvider).value ?? [];

      section.forEach((s) => debugPrint('SectionIdx: ${s.sectionId}'));

      final selectedSectionData = section.firstWhere(
        (s) => s.sectionName == value,
      );
      selectSection(value, selectedSectionData.sectionId);

      debugPrint('SectionId: ${state.selectedSectionId}');

      return false;
    }

    if (state.currentStep == RecordStep.language) {
      selectedLanguage(value);
      return true;
    }

    return false;
  }

  List<String> get currentOptions {
    final sectionsAsync = ref.watch(sectionProvider);
    final gradeLevelsAsync = ref.watch(gradeLevelProvider);

    debugPrint('SelectedGrade: ${state.selectedGrade}');
    debugPrint('SelectedGradeLevelId: ${state.selectedGradeLevelId}');

    return switch (state.currentStep) {
      RecordStep.grade => gradeLevelsAsync.when(
        data: (grades) {
          return grades.map((g) => 'Grade ${g.gradeNumber}').toList();
        },
        loading: () => [],
        error: (_, __) => [],
      ),

      RecordStep.section => sectionsAsync.when(
        data: (sections) {
          final filteredSections =
              sections.where((section) {
                return section.gradeLevelId == state.selectedGradeLevelId;
              }).toList();

          return filteredSections.map((s) => s.sectionName ?? '').toList();
        },
        loading: () => [],
        error: (_, __) => [],
      ),

      RecordStep.language => ['English', 'Filipino'],
    };
  }

  String get currentTitle {
    switch (state.currentStep) {
      case RecordStep.grade:
        return 'Grade Level';
      case RecordStep.section:
        return 'Section (${state.selectedGrade})';
      case RecordStep.language:
        return 'Language (${state.selectedGrade} • ${state.selectedSection})';
    }
  }
}
