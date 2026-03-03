import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RecordStep { grade, section, language }

class RecordState {
  final RecordStep currentStep;
  final int? selectedGrade;
  final int? selectedSection;

  const RecordState({
    this.currentStep = RecordStep.grade,
    this.selectedGrade,
    this.selectedSection,
  });

  RecordState copyWith({
    RecordStep? currentStep,
    int? selectedGrade,
    int? selectedSection,
  }) {
    return RecordState(
      currentStep: currentStep ?? this.currentStep,
      selectedGrade: selectedGrade ?? this.selectedGrade,
      selectedSection: selectedSection ?? this.selectedSection,
    );
  }
}

class RecordNotifier extends Notifier<RecordState> {
  @override
  RecordState build() {
    return const RecordState();
  }

  void selectGrade(int grade) {
    state = state.copyWith(
      selectedGrade: grade,
      currentStep: RecordStep.section,
    );
  }

  void selectSection(int section) {
    state = state.copyWith(
      selectedSection: section,
      currentStep: RecordStep.language,
    );
  }

  void goBack() {
    if (state.currentStep == RecordStep.language) {
      state = state.copyWith(currentStep: RecordStep.section);
    } else if (state.currentStep == RecordStep.section) {
      state = state.copyWith(currentStep: RecordStep.grade);
    }
  }
}
