import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WordColorNotifier extends Notifier<List<Color?>> {
  @override
  List<Color?> build() => [];

  void initialize(String content) {
    final words = content.split(" ");
    state = List.generate(words.length, (_) => null);
  }

  void colorWord(int index, Color color) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) color else state[i],
    ];
  }

  void reset() {
    state = List.generate(state.length, (_) => null);
  }
}
