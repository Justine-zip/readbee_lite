String comprehensionLevel(int score) {
  return (score >= 4
      ? 'Independent'
      : (score >= 2 ? 'Instructional' : 'Frustration'));
}

double comprehensionRate(int total, int score) {
  return (score / total) * 100;
}

int totalCorrect({
  required Map<int, String> selectedAnswers,
  required List<List<String>> choices,
  required List<int> answerKey,
}) {
  int correct = 0;

  selectedAnswers.forEach((questionIndex, studentAnswer) {
    final correctIndex = answerKey[questionIndex];

    if (studentAnswer == choices[questionIndex][correctIndex]) {
      correct++;
    }
  });

  return correct;
}

int totalWrong({required int totalQuestions, required int totalCorrect}) {
  return totalQuestions - totalCorrect;
}
