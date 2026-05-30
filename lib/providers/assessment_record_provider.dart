import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/assessment_record.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final assessmentRecordProvider = FutureProvider<List<AssessmentRecord>?>((
  ref,
) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('assessment_records')
      .select('*')
      .eq('evaluator_user_id', supabase.auth.currentUser!.id);

  debugPrint(
    'AssessmentRecordData: ${response.map((r) => r['assessment_record_id'])}',
  );

  return response.map<AssessmentRecord>((assessment) {
    return AssessmentRecord(
      assessmentRecordId: assessment['assessment_record_id'] ?? '',
      pupilId: assessment['pupil_id'] ?? '',
      evaluatorId: assessment['evaluator_user_id'] ?? '',
      materialId: assessment['material_id'] ?? '',
      scheduleId: assessment['schedule_id'] ?? '',
      yearId: assessment['year_id'] ?? '',
      quarterId: assessment['quarter_id'] ?? '',
      assignmentId: assessment['assignment_id'] ?? '',
      assessmentMethod: assessment['assessment_method'] ?? '',
      assessmentType: assessment['assessment_type'] ?? '',
      readingScore: assessment['reading_score'] ?? [],
      comprehensionScore: assessment['comprehension_score'] ?? [],
      totalScore: assessment['total_score'] ?? 0,
      readingLevel: assessment['reading_level'] ?? '',
      status: assessment['status'] ?? '',
      miscueContent: assessment['miscue_content'] ?? [],
    );
  }).toList();
});
