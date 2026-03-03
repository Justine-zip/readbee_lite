import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/providers/section_provider.dart';

enum RecordStep { grade, section, language }

class RecordState {
  final RecordStep currentStep;
  final String? selectedGrade;
  final String? selectedSection;
  final String? selectedLanguage;

  const RecordState({
    this.currentStep = RecordStep.grade,
    this.selectedGrade,
    this.selectedSection,
    this.selectedLanguage,
  });

  RecordState copyWith({
    RecordStep? currentStep,
    String? selectedGrade,
    String? selectedSection,
    String? selectedLanguage,
  }) {
    return RecordState(
      currentStep: currentStep ?? this.currentStep,
      selectedGrade: selectedGrade ?? this.selectedGrade,
      selectedSection: selectedSection ?? this.selectedSection,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }
}

class RecordNotifier extends Notifier<RecordState> {
  @override
  RecordState build() {
    return const RecordState();
  }

  void selectGrade(String grade) {
    state = state.copyWith(
      selectedGrade: grade,
      currentStep: RecordStep.section,
    );
  }

  void selectSection(String section) {
    state = state.copyWith(
      selectedSection: section,
      currentStep: RecordStep.language,
    );
  }

  void selectedLanguage(String language) {
    state = state.copyWith(selectedLanguage: language);
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
      selectGrade(value);
      return false;
    }

    if (state.currentStep == RecordStep.section) {
      selectSection(value);
      return false;
    }

    if (state.currentStep == RecordStep.language) {
      selectedLanguage(value);
      return true;
    }

    return false;
  }

  List<String> get currentOptions {
    final sections = ref.watch(sectionProvider);

    switch (state.currentStep) {
      case RecordStep.grade:
        return ['Grade 3', 'Grade 4', 'Grade 5', 'Grade 6'];
      case RecordStep.section:
        return sections.map((s) => s.section).toList();
      case RecordStep.language:
        return ['English', 'Tagalog'];
    }
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
