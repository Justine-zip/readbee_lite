import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/choice_item.dart';
import 'package:readbee_lite/models/quiz_question.dart';
import 'package:readbee_lite/viewmodels/providers/selected_material_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final quizQuestionProvider = FutureProvider<List<QuizQuestion>>((ref) async {
  final supabase = Supabase.instance.client;

  final selectedMaterial = ref.watch(selectedMaterialProvider);

  if (selectedMaterial == null) {
    return [];
  }

  final response = await supabase
      .from('quiz_questions')
      .select('*')
      .eq('quiz_id', selectedMaterial.quizId);

  debugPrint('QuizQuestionData: $response');

  return response.map<QuizQuestion>((json) {
    return QuizQuestion(
      questionId: json['question_id'] ?? '',
      quizId: json['quiz_id'] ?? '',
      questionText: json['question_text'] ?? '',
      choices:
          (json['choices'] as List<dynamic>? ?? [])
              .map((e) => ChoiceItem.fromMap(e))
              .toList(),
      correctAnswer: json['correct_answer'] ?? 0,
      points: json['points'] ?? 0,
      questionOrder: json['question_order'] ?? 0,
    );
  }).toList();
});
