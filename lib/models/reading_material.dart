class ReadingMaterial {
  final String title;
  final String content;
  final String language;
  final List<String> question;
  final List<List<String>> choice;
  final List<int> key;
  final int wordLength;
  final int storyId;
  final int quizId;

  ReadingMaterial({
    required this.title,
    required this.content,
    required this.language,
    required this.question,
    required this.choice,
    required this.key,
    required this.wordLength,
    required this.storyId,
    required this.quizId,
  });

  factory ReadingMaterial.fromMap(Map<String, dynamic> json) {
    return ReadingMaterial(
      title: json['title'],
      content: json['content'],
      language: json['language'],
      question: json['question'],
      choice: json['choice'],
      key: json['key'],
      wordLength: json['wordLength'],
      storyId: json['storyId'],
      quizId: json['quizId'],
    );
  }
}
