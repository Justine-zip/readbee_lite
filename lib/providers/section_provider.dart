import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/section.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sectionProvider = FutureProvider<List<Section>?>((ref) async {
  final supabase = Supabase.instance.client;

  final response = await supabase.from('class_sections').select('*');

  debugPrint('SectionData: $response');

  return response.map<Section>((sections) {
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
