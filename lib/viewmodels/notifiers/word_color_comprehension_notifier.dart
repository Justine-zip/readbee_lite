import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/viewmodels/providers/quiz_question_provider.dart';
import 'package:readbee_lite/viewmodels/providers/selected_material_provider.dart';

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
    ref.watch(selectedMaterialProvider);

    final questionAsync = ref.watch(quizQuestionProvider);

    return questionAsync.when(
      data: (questions) {
        return WordColorComprehensionState(
          key: questions.map((q) => q.correctAnswer).toList(),
          selectedAnswers: {},
        );
      },

      loading: () {
        return WordColorComprehensionState(key: [], selectedAnswers: {});
      },

      error: (error, stackTrace) {
        return WordColorComprehensionState(key: [], selectedAnswers: {});
      },
    );
  }

  void selectAnswer(int questionIndex, int choiceIndex) {
    state = state.copyWith(
      selectedAnswers: {...state.selectedAnswers, questionIndex: choiceIndex},
    );
  }
}
