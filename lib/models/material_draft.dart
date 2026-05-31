import 'package:flutter/foundation.dart';

@immutable
class QuizQuestionDraft {
  final String question;
  final List<QuizChoice> choices;
  final String correctAnswer;

  const QuizQuestionDraft({
    required this.question,
    required this.choices,
    required this.correctAnswer,
  });
}

@immutable
class QuizChoice {
  final String choice;
  final String letter;

  const QuizChoice({required this.choice, required this.letter});

  Map<String, dynamic> toJson() => {'choice': choice, 'letter': letter};
}

@immutable
class ReadingMaterialDraft {
  final String title;
  final String content;
  final String language;
  final int wordCount;
  final String? gradeLevelId;

  final List<QuizQuestionDraft> questions;

  const ReadingMaterialDraft({
    this.title = '',
    this.content = '',
    this.language = '',
    this.wordCount = 0,
    this.gradeLevelId,
    this.questions = const [],
  });

  ReadingMaterialDraft copyWith({
    String? title,
    String? content,
    String? language,
    int? wordCount,
    String? gradeLevelId,
    List<QuizQuestionDraft>? questions,
  }) {
    return ReadingMaterialDraft(
      title: title ?? this.title,
      content: content ?? this.content,
      language: language ?? this.language,
      wordCount: wordCount ?? this.wordCount,
      gradeLevelId: gradeLevelId ?? this.gradeLevelId,
      questions: questions ?? this.questions,
    );
  }
}
