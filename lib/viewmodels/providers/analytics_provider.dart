import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnalyticsFilter {
  final String? language;
  final String? yearId;
  final int? quarterId;
  final String? gradeLevelId;

  const AnalyticsFilter({
    this.language,
    this.yearId,
    this.quarterId,
    this.gradeLevelId,
  });

  AnalyticsFilter copyWith({
    bool clearLanguage = false,
    String? language,

    bool clearYearId = false,
    String? yearId,

    bool clearQuarterId = false,
    int? quarterId,

    bool clearGradeLevelId = false,
    String? gradeLevelId,
  }) {
    return AnalyticsFilter(
      language: clearLanguage ? null : (language ?? this.language),

      yearId: clearYearId ? null : (yearId ?? this.yearId),

      quarterId: clearQuarterId ? null : (quarterId ?? this.quarterId),

      gradeLevelId:
          clearGradeLevelId ? null : (gradeLevelId ?? this.gradeLevelId),
    );
  }
}

final analyticsFilterProvider = StateProvider<AnalyticsFilter>((ref) {
  return const AnalyticsFilter();
});

final readingSpeedProvider = FutureProvider<List<String>>((ref) async {
  final supabase = Supabase.instance.client;
  final filter = ref.watch(analyticsFilterProvider);

  var query = supabase.from('assessment_records').select('''
        reading_score,
        year_id,
        quarter_id,
        material:material_id (
          language,
          grade_level_id
        )
      ''');

  if (filter.yearId != null) {
    query = query.eq('year_id', filter.yearId!);
  }

  if (filter.quarterId != null) {
    query = query.eq('quarter_id', filter.quarterId!);
  }

  final rows = await query;

  final filteredRows =
      rows.where((row) {
        final material = row['material'];

        if (filter.language != null) {
          if (material == null || material['language'] != filter.language) {
            return false;
          }
        }

        if (filter.gradeLevelId != null) {
          if (material == null ||
              material['grade_level_id'] != filter.gradeLevelId) {
            return false;
          }
        }

        return true;
      }).toList();

  return filteredRows.map<String>((row) {
    final readingScore = row['reading_score'];

    if (readingScore == null) {
      return 'Unknown';
    }

    final overallSummary =
        readingScore['miscueOverallSummary'] as List<dynamic>?;

    if (overallSummary == null) {
      return 'Unknown';
    }

    final readingSpeed = overallSummary.firstWhere(
      (item) => item['type'] == 'Reading Speed',
      orElse: () => {'count': 'Unknown'},
    );

    return readingSpeed['count'].toString();
  }).toList();
});

final readingLevelProvider = FutureProvider<List<String>>((ref) async {
  final supabase = Supabase.instance.client;
  final filter = ref.watch(analyticsFilterProvider);

  var query = supabase.from('assessment_records').select('''
        reading_score,
        year_id,
        quarter_id,
        material:material_id (
          language,
          grade_level_id
        )
      ''');

  if (filter.yearId != null) {
    query = query.eq('year_id', filter.yearId!);
  }

  if (filter.quarterId != null) {
    query = query.eq('quarter_id', filter.quarterId!);
  }

  final rows = await query;

  final filteredRows =
      rows.where((row) {
        final material = row['material'];

        if (filter.language != null) {
          if (material == null || material['language'] != filter.language) {
            return false;
          }
        }

        if (filter.gradeLevelId != null) {
          if (material == null ||
              material['grade_level_id'] != filter.gradeLevelId) {
            return false;
          }
        }

        return true;
      }).toList();

  return filteredRows.map<String>((row) {
    final readingScore = row['reading_score'];

    if (readingScore == null) {
      return 'Unknown';
    }

    final overallSummary =
        readingScore['miscueOverallSummary'] as List<dynamic>?;

    if (overallSummary == null) {
      return 'Unknown';
    }

    final readingLevel = overallSummary.firstWhere(
      (item) => item['type'] == 'Reading Level',
      orElse: () => {'count': 'Unknown'},
    );

    return readingLevel['count'].toString();
  }).toList();
});

final comprehensionLevelProvider = FutureProvider<List<String>>((ref) async {
  final supabase = Supabase.instance.client;
  final filter = ref.watch(analyticsFilterProvider);

  var query = supabase.from('assessment_records').select('''
        comprehension_score,
        year_id,
        quarter_id,
        material:material_id (
          language,
          grade_level_id
        )
      ''');

  if (filter.yearId != null) {
    query = query.eq('year_id', filter.yearId!);
  }

  if (filter.quarterId != null) {
    query = query.eq('quarter_id', filter.quarterId!);
  }

  final rows = await query;

  final filteredRows =
      rows.where((row) {
        final material = row['material'];

        if (filter.language != null) {
          if (material == null || material['language'] != filter.language) {
            return false;
          }
        }

        if (filter.gradeLevelId != null) {
          if (material == null ||
              material['grade_level_id'] != filter.gradeLevelId) {
            return false;
          }
        }

        return true;
      }).toList();

  return filteredRows.map<String>((row) {
    final comprehensionScore = row['comprehension_score'];

    if (comprehensionScore == null) {
      return 'Unknown';
    }

    final overallSummary =
        comprehensionScore['comprehensionSummary'] as List<dynamic>?;

    if (overallSummary == null) {
      return 'Unknown';
    }

    final comprehensionLevel = overallSummary.firstWhere(
      (item) => item['type'] == 'Comprehension Score',
      orElse: () => {'count': 'Unknown'},
    );

    return comprehensionLevel['count'].toString();
  }).toList();
});

final schoolYearsProvider = FutureProvider((ref) async {
  final supabase = Supabase.instance.client;

  return await supabase.from('school_year').select().order('start_date');
});

final quartersProvider = FutureProvider((ref) async {
  final supabase = Supabase.instance.client;

  return await supabase.from('quarter').select().order('quarter_number');
});

final gradeLevelsProvider = FutureProvider((ref) async {
  final supabase = Supabase.instance.client;

  return await supabase.from('grade_levels').select().order('grade_number');
});

final languagesProvider = FutureProvider<List<String>>((ref) async {
  final supabase = Supabase.instance.client;

  final result = await supabase.from('reading_materials').select('language');

  final languages =
      result
          .map((e) => e['language'] as String?)
          .whereType<String>()
          .toSet()
          .toList();

  return languages;
});
