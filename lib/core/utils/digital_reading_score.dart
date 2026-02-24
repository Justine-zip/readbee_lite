int totalMiscueCount(List<dynamic> miscues) {
  return miscues.fold(0, (sum, miscue) => (sum + (miscue.count ?? 0)) as int);
}

int totalWords(List<dynamic> words) {
  return words.length;
}
