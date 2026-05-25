import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/pupil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final pupilProvider = FutureProvider<List<Pupil>?>((ref) async {
  final supabase = Supabase.instance.client;

  final response = await supabase.from('pupils').select('*');

  debugPrint('PupilData: $response');

  return response.map<Pupil>((pupil) {
    return Pupil(
      pupilId: pupil['pupil_id'] ?? '',
      lrn: pupil['lrn'] ?? '',
      fullName: pupil['full_name'] ?? '',
      sex: pupil['sex'] ?? '',
      age: pupil['age'] ?? 0,
      guardianName: pupil['guardian_name'] ?? '',
      guardianContact: pupil['guardian_contact'] ?? '',
      schoolId: pupil['school_id'] ?? '',
      sectionId: pupil['section_id'] ?? '',
      gradeLevelId: pupil['grade_level_id'] ?? '',
      status: pupil['status'] ?? '',
    );
  }).toList();
});
