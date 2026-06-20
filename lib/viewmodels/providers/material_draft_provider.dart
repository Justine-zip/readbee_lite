import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/material_draft.dart';

final materialDraftProvider =
    StateNotifierProvider<ReadingMaterialNotifier, ReadingMaterialDraft>((ref) {
      return ReadingMaterialNotifier();
    });

class ReadingMaterialNotifier extends StateNotifier<ReadingMaterialDraft> {
  ReadingMaterialNotifier() : super(const ReadingMaterialDraft());

  void setTitle(String value) {
    state = state.copyWith(title: value);
  }

  void setContent(String value) {
    state = state.copyWith(content: value);
  }

  void setLanguage(String value) {
    state = state.copyWith(language: value);
  }

  void setWordCount(int value) {
    state = state.copyWith(wordCount: value);
  }

  void setGradeLevel(String? value) {
    state = state.copyWith(gradeLevelId: value);
  }

  void addQuestion(QuizQuestionDraft question) {
    state = state.copyWith(questions: [...state.questions, question]);
  }

  void removeQuestion(int index) {
    final updated = [...state.questions];
    updated.removeAt(index);

    state = state.copyWith(questions: updated);
  }

  void reset() {
    state = const ReadingMaterialDraft();
  }
}
