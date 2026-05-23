class Story {
  final String storyId;
  final String title;
  final String content;
  final int wordCount;
  final String language;
  final String gradeLevelId;
  final String status;
  final String createdBy;

  Story({
    required this.storyId,
    required this.title,
    required this.content,
    required this.wordCount,
    required this.language,
    required this.gradeLevelId,
    required this.status,
    required this.createdBy,
  });

  factory Story.fromMap(Map<String, dynamic> json) {
    return Story(
      storyId: json['story_id'],
      title: json['title'],
      content: json['content'],
      wordCount: json['word_count'],
      language: json['language'],
      gradeLevelId: json['grade_level_id'],
      status: json['status'],
      createdBy: json['created_by'],
    );
  }
}
