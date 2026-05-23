import 'package:readbee_lite/models/choice_item.dart';

class QuizQuestion {
  final String questionId;
  final String quizId;
  final String questionText;
  final List<ChoiceItem> choices;
  final int correctAnswer;
  final int points;
  final int questionOrder;

  QuizQuestion({
    required this.questionId,
    required this.quizId,
    required this.questionText,
    required this.choices,
    required this.correctAnswer,
    required this.points,
    required this.questionOrder,
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> json) {
    return QuizQuestion(
      questionId: json['question_id'],
      quizId: json['quiz_id'],
      questionText: json['question_text'],
      choices: json['choices'],
      correctAnswer: json['correct_answer'],
      points: json['points'],
      questionOrder: json['question_order'],
    );
  }
}
