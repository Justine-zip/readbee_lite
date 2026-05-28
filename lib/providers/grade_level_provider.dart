import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/grade_level.dart';
import 'package:readbee_lite/providers/section_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final gradeLevelProvider = FutureProvider<List<GradeLevel>>((ref) async {
  final supabase = Supabase.instance.client;

  final sectionAsync = ref.watch(sectionProvider);

  return sectionAsync.when(
    data: (sections) async {
      final gradeLevelIds =
          sections
              .map((s) => s.gradeLevelId)
              .whereType<String>()
              .toSet()
              .toList();

      debugPrint('GradeLevelID: $gradeLevelIds');

      if (gradeLevelIds.isEmpty) return [];

      final response = await supabase
          .from('grade_levels')
          .select('*')
          .inFilter('grade_level_id', gradeLevelIds);

      debugPrint('GradeLevelData: $response');

      return (response as List).map((g) {
        return GradeLevel(
          gradeLevelId: g['grade_level_id'],
          schoolId: g['school_id'],
          gradeNumber: g['grade_number'],
          isActive: g['is_active'],
        );
      }).toList();
    },
    loading: () async => [],
    error: (_, __) async => [],
  );
});
