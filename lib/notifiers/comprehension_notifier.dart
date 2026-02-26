import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComprehensionState {
  final int currentQuestionIndex;
  final Map<int, String> selectedAnswers;
  final bool isFinished;

  ComprehensionState({
    required this.currentQuestionIndex,
    required this.selectedAnswers,
    required this.isFinished,
  });

  ComprehensionState copyWith({
    int? currentQuestionIndex,
    Map<int, String>? selectedAnswers,
    bool? isFinished,
  }) {
    return ComprehensionState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

class ComprehensionNotifier extends StateNotifier<ComprehensionState> {
  ComprehensionNotifier()
    : super(
        ComprehensionState(
          currentQuestionIndex: 0,
          selectedAnswers: {},
          isFinished: false,
        ),
      );

  void selectAnswer({required int totalQuestions, required String answer}) {
    final currentIndex = state.currentQuestionIndex;

    final updatedAnswers = {...state.selectedAnswers, currentIndex: answer};

    if (currentIndex < totalQuestions - 1) {
      state = state.copyWith(
        selectedAnswers: updatedAnswers,
        currentQuestionIndex: currentIndex + 1,
      );
    } else {
      state = state.copyWith(selectedAnswers: updatedAnswers, isFinished: true);
    }
  }

  void undoAnswer() {
    final currentIndex = state.currentQuestionIndex;

    if (currentIndex > 0) {
      final updatedAnswers = Map<int, String>.from(state.selectedAnswers);

      // Remove the previous question's answer
      updatedAnswers.remove(currentIndex - 1);

      state = state.copyWith(
        selectedAnswers: updatedAnswers,
        currentQuestionIndex: currentIndex - 1,
        isFinished: false,
      );
    }
  }

  void reset() {
    state = ComprehensionState(
      currentQuestionIndex: 0,
      selectedAnswers: {},
      isFinished: false,
    );
  }

  void resetFinished() {
    state = state.copyWith(isFinished: false);
  }
}
