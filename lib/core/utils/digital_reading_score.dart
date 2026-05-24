int totalMiscueCount(List<dynamic> miscues) {
  return miscues
      .where((miscue) => miscue.name != 'Correct')
      .fold(0, (sum, miscue) => (sum + (miscue.count ?? 0)) as int);
}

int totalWords(List<dynamic> words) {
  return words.length;
}

String readingLevel(int score, int totalWords) {
  double readScore = ((score / totalWords) * 100);
  return (readScore < 90
      ? 'Frustration'
      : (readScore < 97 ? 'Instructional' : 'Independent'));
}

int wordPerMinute(double time, int readWords) {
  if (time <= 0) return 0;
  return ((readWords / time) * 60).toInt();
}

String classifyReadingSpeed(int wpm) {
  if (wpm >= 120) {
    return 'Fast';
  } else if (wpm >= 80) {
    return 'Average';
  } else if (wpm >= 50) {
    return 'Slow';
  } else if (wpm >= 10) {
    return 'Struggling';
  } else {
    return 'Non-reader';
  }
}
