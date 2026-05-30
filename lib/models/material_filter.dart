class MaterialFilter {
  final String? gradeLevel;
  final String? gradeLevelId;
  final String? language;

  const MaterialFilter({this.gradeLevel, this.gradeLevelId, this.language});

  MaterialFilter copyWith({
    String? gradeLevel,
    String? gradeLevelId,
    String? language,
  }) {
    return MaterialFilter(
      gradeLevel: gradeLevel ?? this.gradeLevel,
      gradeLevelId: gradeLevelId ?? this.gradeLevelId,
      language: language ?? this.language,
    );
  }

  static const empty = MaterialFilter();
}
