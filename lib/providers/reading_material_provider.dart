import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:readbee_lite/models/reading_material.dart';

final readingMaterialProvider = FutureProvider<List<ReadingMaterial>>((
  ref,
) async {
  final supabase = Supabase.instance.client;

  final response = await supabase.from('reading_materials').select('''
        *,
        stories (
          content,
          language,
          word_count
        ),
        quizzes (
          quiz_questions (
            question_text,
            choices,
            correct_answer
          )
        )
      ''');

  return response.map<ReadingMaterial>((json) {
    final story = json['stories'];

    return ReadingMaterial(
      // reading_materials
      materialId: json['material_id'] ?? '',

      title: json['title'] ?? '',

      description: json['description'],

      coverImage: json['cover_image'] ?? '',

      wordCount: json['word_count'],

      gradeLevelId: json['grade_level_id'].toString(),

      uploadedBy: json['uploaded_by'].toString(),

      approvedBy: json['approved_by'].toString(),

      status: json['status'] ?? 'draft',

      schoolId: json['school_id'].toString(),

      language: story?['language'] ?? json['language'] ?? '',

      storyId: json['story_id'] ?? '',

      // quizzes
      quizId: json['quiz_id'] ?? '',
    );
  }).toList();
});
