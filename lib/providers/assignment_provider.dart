import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/assignment.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final assignmentProvider = FutureProvider<List<Assignment>?>((ref) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('assigned_evaluators')
      .select('*')
      .eq('evaluator_user_id', supabase.auth.currentUser!.id);

  debugPrint('AssignmentData: $response');

  return response.map<Assignment>((item) {
    return Assignment(
      assignmentId: item['assignment_id'],
      scheduleId: item['schedule_id'],
      evaluatorId: item['evaluator_user_id'],
      sectionId: item['section_id'],
      yearId: item['year_id'],
      quarterId: item['quarter_id'],
      assignedBy: item['assigned_by'],
      confirmationStatus: item['confirmation_status'],
      assessmentDate: item['assessment_date'],
      reportStatus: item['report_status'],
      assessmentStatus: item['assessment_status'],
    );
  }).toList();
});
