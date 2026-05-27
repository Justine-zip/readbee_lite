import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final readingSpeedProvider = StreamProvider<List<String>>((ref) {
  final supabase = Supabase.instance.client;

  return supabase.from('assessment_records').stream(primaryKey: ['id']).map((
    rows,
  ) {
    return rows.map<String>((row) {
      final readingScore = row['reading_score'];

      if (readingScore == null) {
        return 'Unknown';
      }

      final overallSummary =
          readingScore['miscueOverallSummary'] as List<dynamic>;

      final readingSpeed = overallSummary.firstWhere(
        (item) => item['type'] == 'Reading Speed',
        orElse: () => {'count': 'Unknown'},
      );

      return readingSpeed['count'].toString();
    }).toList();
  });
});

final readingLevelProvider = StreamProvider<List<String>>((ref) {
  final supabase = Supabase.instance.client;

  return supabase.from('assessment_records').stream(primaryKey: ['id']).map((
    rows,
  ) {
    return rows.map<String>((row) {
      final readingScore = row['reading_score'];

      if (readingScore == null) {
        return 'Unknown';
      }

      final overallSummary =
          readingScore['miscueOverallSummary'] as List<dynamic>;

      final readingLevel = overallSummary.firstWhere(
        (item) => item['type'] == 'Reading Level',
        orElse: () => {'count': 'Unknown'},
      );

      return readingLevel['count'].toString();
    }).toList();
  });
});

final comprehensionLevelProvider = StreamProvider<List<String>>((ref) {
  final supabase = Supabase.instance.client;

  return supabase.from('assessment_records').stream(primaryKey: ['id']).map((
    rows,
  ) {
    return rows.map<String>((row) {
      final comprehensionScore = row['comprehension_score'];

      if (comprehensionScore == null) {
        return 'Unknown';
      }

      final overallSummary =
          comprehensionScore['comprehensionSummary'] as List<dynamic>;

      final comprehensionLevel = overallSummary.firstWhere(
        (item) => item['type'] == 'Comprehension Score',
        orElse: () => {'count': 'Unknown'},
      );

      return comprehensionLevel['count'].toString();
    }).toList();
  });
});
