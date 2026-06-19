import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/story.dart';
import 'package:readbee_lite/viewmodels/providers/selected_material_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final storyProvider = FutureProvider<Story?>((ref) async {
  final supabase = Supabase.instance.client;

  final selectedMaterial = ref.watch(selectedMaterialProvider);

  debugPrint('SelectedMaterial: $selectedMaterial');

  if (selectedMaterial == null) {
    return null;
  }

  final response =
      await supabase
          .from('stories')
          .select('*')
          .eq('story_id', selectedMaterial.storyId)
          .single();

  debugPrint('StoryData: $response');

  return Story(
    storyId: response['story_id'] ?? '',
    title: response['title'] ?? '',
    content: response['content'] ?? '',
    wordCount: response['word_count'] ?? 0,
    language: response['language'] ?? '',
    gradeLevelId: response['grade_level_id'].toString(),
    status: response['status'] ?? '',
    createdBy: response['created_by'].toString(),
  );
});
