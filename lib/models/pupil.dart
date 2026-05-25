class Pupil {
  final String pupilId;
  final String lrn;
  final String fullName;
  final String sex;
  final int age;
  final String guardianName;
  final String guardianContact;
  final String schoolId;
  final String sectionId;
  final String gradeLevelId;
  final String status;

  Pupil({
    required this.pupilId,
    required this.lrn,
    required this.fullName,
    required this.sex,
    required this.age,
    required this.guardianName,
    required this.guardianContact,
    required this.schoolId,
    required this.sectionId,
    required this.gradeLevelId,
    required this.status,
  });

  factory Pupil.fromMap(Map<String, dynamic> json) {
    return Pupil(
      pupilId: json['pupil_id'],
      lrn: json['lrn'],
      fullName: json['full_name'],
      sex: json['sex'],
      age: json['age'],
      guardianName: json['guardian_name'],
      guardianContact: json['guardian_contact'],
      schoolId: json['school_id'],
      sectionId: json['section_id'],
      gradeLevelId: json['grade_level_id'],
      status: json['status'],
    );
  }
}
