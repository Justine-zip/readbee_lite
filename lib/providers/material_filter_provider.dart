import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/material_filter.dart';
import 'package:readbee_lite/models/reading_material.dart';
import 'package:readbee_lite/providers/grade_level_provider.dart';
import 'package:readbee_lite/providers/reading_material_provider.dart';

final materialFilterProvider = StateProvider<MaterialFilter>((ref) {
  return MaterialFilter.empty;
});

final filteredReadingMaterialProvider = Provider<
  AsyncValue<List<ReadingMaterial>>
>((ref) {
  final materialsAsync = ref.watch(readingMaterialProvider);
  final gradeLevelAsync = ref.watch(gradeLevelProvider);
  final filter = ref.watch(materialFilterProvider);

  return materialsAsync.whenData((materials) {
    final gradeLevels = gradeLevelAsync.value ?? [];

    final selectedGrade = filter.gradeLevel ?? '3';

    final selectedGradeLevelId =
        gradeLevels
            .where((g) => g.gradeNumber.toString() == selectedGrade)
            .firstOrNull
            ?.gradeLevelId;

    return materials.where((material) {
      final gradeMatch = material.gradeLevelId == selectedGradeLevelId;

      debugPrint(
        'gdatax: gradeLevelId: ${material.gradeLevelId} || selectedGradeLevelId: $selectedGradeLevelId',
      );

      final languageMatch =
          filter.language == null || material.language == filter.language;

      return gradeMatch && languageMatch;
    }).toList();
  });
});
