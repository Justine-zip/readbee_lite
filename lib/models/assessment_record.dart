class AssessmentRecord {
  final String assessmentRecordId;
  final String pupilId;
  final String evaluatorId;
  final String materialId;
  final String scheduleId;
  final String yearId;
  final String quarterId;
  final String assignmentId;
  final String assessmentMethod;
  final String assessmentType;
  final Map<String, dynamic> readingScore;
  final Map<String, dynamic> comprehensionScore;
  final double totalScore;
  final String readingLevel;
  final String status;
  final String miscueContent;

  AssessmentRecord({
    required this.assessmentRecordId,
    required this.pupilId,
    required this.evaluatorId,
    required this.materialId,
    required this.scheduleId,
    required this.yearId,
    required this.quarterId,
    required this.assignmentId,
    required this.assessmentMethod,
    required this.assessmentType,
    required this.readingScore,
    required this.comprehensionScore,
    required this.totalScore,
    required this.readingLevel,
    required this.status,
    required this.miscueContent,
  });

  factory AssessmentRecord.fromMap(Map<String, dynamic> json) {
    return AssessmentRecord(
      assessmentRecordId: json['assessment_record_id'],
      pupilId: json['pupil_id'],
      evaluatorId: json['evaluator_user_id'],
      materialId: json['material_id'],
      scheduleId: json['schedule_id'],
      yearId: json['year_id'],
      quarterId: json['quarter_id'],
      assignmentId: json['assignment_id'],
      assessmentMethod: json['assessment_method'],
      assessmentType: json['assessment_type'],
      readingScore: json['reading_score'],
      comprehensionScore: json['comprehension_score'],
      totalScore: json['total_score'],
      readingLevel: json['reading_level'],
      status: json['status'],
      miscueContent: json['miscue_content'],
    );
  }
}
