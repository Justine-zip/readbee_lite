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
