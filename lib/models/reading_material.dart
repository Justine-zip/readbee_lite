class ReadingMaterial {
  final String materialId;
  final String title;
  final String? description;
  final String coverImage;
  final String language;
  final int wordCount;
  final String gradeLevelId;
  final String storyId;
  final String quizId;
  final String? uploadedBy;
  final String? approvedBy;
  final String status;
  final String? schoolId;

  ReadingMaterial({
    required this.materialId,
    required this.title,
    this.description,
    required this.coverImage,
    required this.language,
    required this.wordCount,
    required this.gradeLevelId,
    required this.storyId,
    required this.quizId,
    this.uploadedBy,
    this.approvedBy,
    required this.status,
    this.schoolId,
  });

  factory ReadingMaterial.fromMap(Map<String, dynamic> json) {
    return ReadingMaterial(
      materialId: json['material_id'],
      title: json['title'],
      description: json['description'] ?? '',
      coverImage: json['cover_image'] ?? '',
      language: json['language'],
      wordCount: json['word_count'],
      gradeLevelId: json['grade_level_id'],
      storyId: json['story_id'],
      quizId: json['quiz_id'],
      uploadedBy: json['uploaded_by'] ?? '',
      approvedBy: json['approved_by'] ?? '',
      status: json['status'],
      schoolId: json['school_id'] ?? '',
    );
  }
}
