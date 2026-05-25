class Assignment {
  final String assignmentId;
  final String scheduleId;
  final String evaluatorId;
  final String sectionId;
  final String yearId;
  final String quarterId;
  final String assignedBy;
  final String confirmationStatus;
  final String assessmentStatus;
  final String reportStatus;
  final String assessmentDate;

  Assignment({
    required this.assignmentId,
    required this.scheduleId,
    required this.evaluatorId,
    required this.sectionId,
    required this.yearId,
    required this.quarterId,
    required this.assignedBy,
    required this.confirmationStatus,
    required this.assessmentDate,
    required this.reportStatus,
    required this.assessmentStatus,
  });

  factory Assignment.fromMap(Map<String, dynamic> json) {
    return Assignment(
      assignmentId: json['assignment_id'],
      scheduleId: json['schedule_id'],
      evaluatorId: json['evaluator_user_id'],
      sectionId: json['section_id'],
      yearId: json['year_id'],
      quarterId: json['quarter_id'],
      assignedBy: json['assigned_by'],
      confirmationStatus: json['confirmation_status'],
      assessmentDate: json['assessment_date'],
      reportStatus: json['report_status'],
      assessmentStatus: json['assessment_status'],
    );
  }
}
