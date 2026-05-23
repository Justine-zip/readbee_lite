class Quiz {
  final String quizId;
  final int totalScore;
  final String status;
  final String createdBy;

  Quiz({
    required this.quizId,
    required this.totalScore,
    required this.status,
    required this.createdBy,
  });

  factory Quiz.fromMap(Map<String, dynamic> json) {
    return Quiz(
      quizId: json['quiz_id'],
      totalScore: json['total_score'],
      status: json['status'],
      createdBy: json['created_by'],
    );
  }
}
