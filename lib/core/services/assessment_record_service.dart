import 'package:supabase_flutter/supabase_flutter.dart';

class AssessmentRecordService {
  final supabase = Supabase.instance.client;

  Future<void> insertAssessmentRecord({
    required String pupilId,
    required String evaluatorUserId,
    required String materialId,
    required String yearId,
    required String quarterId,
    required String assessmentMethod,
    required Map<String, dynamic> readingScore,
    required Map<String, dynamic> comprehensionScore,
    required double totalScore,
    required String readingLevel,
    String? scheduleId,
    String? assignmentId,
    String? assessmentType,
    required Map<String, List<int>> miscueContent,
  }) async {
    await supabase.from('assessment_records').insert({
      'pupil_id': pupilId,
      'evaluator_user_id': evaluatorUserId,
      'material_id': materialId,
      'schedule_id': scheduleId,
      'year_id': yearId,
      'quarter_id': quarterId,
      'assessment_method': assessmentMethod,
      'assessment_type': assessmentType,
      'reading_score': readingScore,
      'comprehension_score': comprehensionScore,
      'miscue_content': miscueContent,
      'total_score': totalScore,
      'reading_level': readingLevel,
      'assignment_id': assignmentId,
      'status': 'recorded',
    });
  }
}
