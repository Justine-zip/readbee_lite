import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/providers/assignment_provider.dart';
import 'package:readbee_lite/providers/grade_level_provider.dart';
import 'package:readbee_lite/providers/pupil_provider.dart';
import 'package:readbee_lite/providers/section_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final gradeRateProvider = FutureProvider<Map<String, double>>((ref) async {
  final supabase = Supabase.instance.client;

  final assignmentAsync = await ref.watch(assignmentProvider.future);
  final sectionAsync = ref.watch(sectionProvider).value;
  final gradeLevelAsync = ref.watch(gradeLevelProvider).value;
  final pupilAsync = ref.watch(pupilProvider).value;

  if (assignmentAsync == null ||
      sectionAsync == null ||
      pupilAsync == null ||
      gradeLevelAsync == null) {
    return {};
  }

  final assignmentIds =
      assignmentAsync.map((a) => a.assignmentId).whereType<String>().toList();

  final sectionIds =
      sectionAsync.map((s) => s.sectionId).whereType<String>().toList();

  final gradeLevelIds =
      gradeLevelAsync.map((g) => g.gradeLevelId).whereType<String>().toList();

  final response = await supabase
      .from('assessment_records')
      .select('''
        assessment_record_id,
        assigned_evaluators!inner (
          assignment_id,
          section_id,
          class_sections!inner (
            section_id,
            grade_level_id
          )
        )
      ''')
      .inFilter('assignment_id', assignmentIds)
      .inFilter('assigned_evaluators.class_sections.section_id', sectionIds)
      .inFilter(
        'assigned_evaluators.class_sections.grade_level_id',
        gradeLevelIds,
      );

  final Map<String, int> assessmentPerGrade = {};
  final Map<String, int> pupilPerGrade = {};

  for (final pupil in pupilAsync) {
    final gradeId = pupil.gradeLevelId;

    if (gradeId == null) continue;

    pupilPerGrade[gradeId] = (pupilPerGrade[gradeId] ?? 0) + 1;
  }

  for (final record in response) {
    final evaluator = record['assigned_evaluators'];
    final classSection = evaluator['class_sections'];

    final gradeId = classSection['grade_level_id'];

    if (gradeId == null) continue;

    assessmentPerGrade[gradeId] = (assessmentPerGrade[gradeId] ?? 0) + 1;
  }

  final Map<String, double> completionRates = {};

  for (final gradeId in gradeLevelIds) {
    final assessmentCount = assessmentPerGrade[gradeId] ?? 0;
    final pupilCount = pupilPerGrade[gradeId] ?? 0;

    final rate = pupilCount == 0 ? 0 : assessmentCount / (pupilCount * 2);

    completionRates[gradeId] = rate.toDouble();

    debugPrint(
      'GradeLevel: $gradeId || '
      'Assessments: $assessmentCount || '
      'Pupils: $pupilCount || '
      'Rate: $rate',
    );

    debugPrint('CompletionRate: $completionRates');
  }

  return completionRates;
});

final sectionRateProvider = FutureProvider<Map<String, double>>((ref) async {
  final supabase = Supabase.instance.client;

  final assignmentAsync = await ref.watch(assignmentProvider.future);
  final sectionState = ref.watch(sectionProvider);
  final gradeLevelState = ref.watch(gradeLevelProvider);
  final pupilState = ref.watch(pupilProvider);

  final sectionAsync = sectionState.value;
  final gradeLevelAsync = gradeLevelState.value;
  final pupilAsync = pupilState.value;

  if (assignmentAsync == null ||
      sectionAsync == null ||
      pupilAsync == null ||
      gradeLevelAsync == null) {
    return {};
  }

  final assignmentIds =
      assignmentAsync.map((a) => a.assignmentId).whereType<String>().toList();

  final sectionIds =
      sectionAsync.map((s) => s.sectionId).whereType<String>().toList();

  final response = await supabase
      .from('assessment_records')
      .select('''
        assessment_record_id,
        assigned_evaluators!inner (
          assignment_id,
          section_id,
          class_sections!inner (
            section_id,
            grade_level_id
          )
        )
      ''')
      .inFilter('assignment_id', assignmentIds)
      .inFilter('assigned_evaluators.section_id', sectionIds);

  final Map<String, int> assessmentPerSection = {};
  final Map<String, int> pupilPerSection = {};

  for (final pupil in pupilAsync) {
    final sectionId = pupil.sectionId;
    if (sectionId == null) continue;

    pupilPerSection[sectionId] = (pupilPerSection[sectionId] ?? 0) + 1;
  }

  for (final record in response) {
    final evaluator = record['assigned_evaluators'];
    final section = evaluator['class_sections'];

    final sectionId = section['section_id'];
    if (sectionId == null) continue;

    assessmentPerSection[sectionId] =
        (assessmentPerSection[sectionId] ?? 0) + 1;
  }

  final Map<String, double> completionRates = {};

  for (final sectionId in sectionIds) {
    final assessmentCount = assessmentPerSection[sectionId] ?? 0;
    final pupilCount = pupilPerSection[sectionId] ?? 0;

    final rate = pupilCount == 0 ? 0 : assessmentCount / (pupilCount * 2);

    completionRates[sectionId] = rate.toDouble();

    debugPrint(
      'Section: $sectionId || '
      'Assessments: $assessmentCount || '
      'Pupils: $pupilCount || '
      'Rate: $rate',
    );
  }

  debugPrint('CompletionRates: $completionRates');

  return completionRates;
});
