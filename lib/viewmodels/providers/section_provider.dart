import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/section.dart';
import 'package:readbee_lite/viewmodels/providers/assignment_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sectionProvider = FutureProvider<List<Section>>((ref) async {
  final supabase = Supabase.instance.client;

  final assignments = await ref.watch(assignmentProvider.future);

  if (assignments == null) return [];

  final sectionIds =
      assignments.map((e) => e.sectionId).whereType<String>().toList();

  final response = await supabase
      .from('class_sections')
      .select('*')
      .inFilter('section_id', sectionIds);

  debugPrint('SectionData: $response');

  return (response as List).map((sections) {
    return Section(
      sectionId: sections['section_id'],
      schoolId: sections['school_id'],
      yearId: sections['year_id'],
      gradeLevelId: sections['grade_level_id'],
      sectionName: sections['section_name'],
      status: sections['status'],
      adviserName: sections['adviser_name'],
    );
  }).toList();
});
