class ChoiceItem {
  final String letter;
  final String choice;

  ChoiceItem({required this.letter, required this.choice});

  factory ChoiceItem.fromMap(Map<String, dynamic> json) {
    return ChoiceItem(
      letter: json['letter'] ?? '',
      choice: json['choice'] ?? '',
    );
  }
}
