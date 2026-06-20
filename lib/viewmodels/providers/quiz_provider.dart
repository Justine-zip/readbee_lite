import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/quiz.dart';
import 'package:readbee_lite/viewmodels/providers/selected_material_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final quizProvider = FutureProvider<Quiz?>((ref) async {
  final supabase = Supabase.instance.client;

  final selectedMaterial = ref.watch(selectedMaterialProvider);

  if (selectedMaterial == null) {
    return null;
  }

  final response =
      await supabase
          .from('quizzes')
          .select('*')
          .eq('quiz_id', selectedMaterial.quizId)
          .single();

  return Quiz(
    quizId: response['quiz_id'] ?? '',
    totalScore: response['total_score'] ?? 0,
    status: response['status'] ?? '',
    createdBy: response['created_by'] ?? '',
  );
});
