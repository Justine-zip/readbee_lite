import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/providers/reading_material_provider.dart';

class WordColorComprehensionState {
  final List<int> key;
  final Map<int, int> selectedAnswers;

  WordColorComprehensionState({
    required this.key,
    required this.selectedAnswers,
  });

  WordColorComprehensionState copyWith({
    List<int>? key,
    Map<int, int>? selectedAnswers,
  }) {
    return WordColorComprehensionState(
      key: key ?? this.key,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
    );
  }
}

class WordColorComprehensionNotifier
    extends Notifier<WordColorComprehensionState> {
  @override
  WordColorComprehensionState build() {
    final material = ref.read(readingMaterialProvider);

    return WordColorComprehensionState(
      key: material[0].key,
      selectedAnswers: {},
    );
  }

  void selectAnswer(int questionIndex, int choiceIndex) {
    state = state.copyWith(
      selectedAnswers: {...state.selectedAnswers, questionIndex: choiceIndex},
    );
  }
}
