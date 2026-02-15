import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/record_state.dart';

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
