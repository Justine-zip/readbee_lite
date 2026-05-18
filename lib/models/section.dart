class Section {
  final String section;
  final String sectionId;
  final String? teacherId;
  final String? classId;
  final String? schoolId;
  final String? yearId;

  Section({
    required this.section,
    required this.sectionId,
    this.teacherId,
    this.classId,
    this.schoolId,
    this.yearId,
  });

  factory Section.fromMap(Map<String, dynamic> json) {
    return Section(section: json['section'], sectionId: json['sectionId']);
  }
}
