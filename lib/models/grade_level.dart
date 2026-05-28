class GradeLevel {
  final String gradeLevelId;
  final String schoolId;
  final int gradeNumber;
  final bool isActive;

  GradeLevel({
    required this.gradeLevelId,
    required this.schoolId,
    required this.gradeNumber,
    required this.isActive,
  });

  factory GradeLevel.fromMap(Map<String, dynamic> json) {
    return GradeLevel(
      gradeLevelId: json['grade_level_id'],
      schoolId: json['school_id'],
      gradeNumber: json['grade_number'],
      isActive: json['is_active'],
    );
  }
}
