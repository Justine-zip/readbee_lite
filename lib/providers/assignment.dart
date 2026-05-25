import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/assignment.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final assignmentProvider = FutureProvider<Assignment?>((ref) async {
  final supabase = Supabase.instance.client;

  final response =
      await supabase
          .from('assigned_evaluators')
          .select('*')
          .eq('evaluator_user_id', supabase.auth.currentUser!.id)
          .single();

  debugPrint('AssignmentData: $response');

  return Assignment(
    assignmentId: response['assignment_id'],
    scheduleId: response['schedule_id'],
    evaluatorId: response['evaluator_user_id'],
    sectionId: response['section_id'],
    yearId: response['year_id'],
    quarterId: response['quarter_id'],
    assignedBy: response['assigned_by'],
    confirmationStatus: response['confirmation_status'],
    assessmentDate: response['assessment_date'],
    reportStatus: response['report_status'],
    assessmentStatus: response['assessment_status'],
  );
});
