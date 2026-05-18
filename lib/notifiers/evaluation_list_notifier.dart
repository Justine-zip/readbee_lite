import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/student.dart';

class EvaluationState {
  final String? selectedSectionId;
  final String? selectedSection;
  final Student? selectedStudent;

  const EvaluationState({
    this.selectedSectionId,
    this.selectedSection,
    this.selectedStudent,
  });

  EvaluationState copyWith({
    String? selectedSectionId,
    String? selectedSection,
    Student? selectedStudent,
  }) {
    return EvaluationState(
      selectedSectionId: selectedSectionId ?? this.selectedSectionId,
      selectedSection: selectedSection ?? this.selectedSection,
      selectedStudent: selectedStudent,
    );
  }
}

class EvaluationNotifier extends Notifier<EvaluationState> {
  @override
  EvaluationState build() {
    return const EvaluationState();
  }

  void selectSection(String sectionId, String section) {
    state = EvaluationState(
      selectedSectionId: sectionId,
      selectedSection: section,
      selectedStudent: null,
    );
  }

  void selectStudent(Student student) {
    state = state.copyWith(selectedStudent: student);
  }

  List<Student> filteredStudents(List<Student> students) {
    if (state.selectedSectionId == null) return [];
    return students
        .where((s) => s.sectionId == state.selectedSectionId)
        .toList();
  }

  void evaluate() {
    if (state.selectedStudent != null) {
      debugPrint("Evaluating: ${state.selectedStudent!.name}");
    }
  }

  void reset() {
    state = const EvaluationState();
  }
}
