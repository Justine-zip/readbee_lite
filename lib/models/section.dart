class Section {
  final String sectionId;
  final String? schoolId;
  final String? yearId;
  final String? gradeLevelId;
  final String? sectionName;
  final String? status;
  final String? adviserName;

  Section({
    required this.sectionId,
    required this.schoolId,
    required this.yearId,
    required this.gradeLevelId,
    this.sectionName,
    this.status,
    this.adviserName,
  });

  factory Section.fromMap(Map<String, dynamic> json) {
    return Section(
      sectionId: json['section_id'],
      schoolId: json['school_id'],
      yearId: json['year_id'],
      gradeLevelId: json['grade_level_id'],
      sectionName: json['section_name'],
      status: json['status'],
      adviserName: json['adviser_name'],
    );
  }
}
