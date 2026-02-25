import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/providers/reading_material_provider.dart';

class WordColorState {
  final int currentIndex;
  final List<Color?> wordColors;
  final bool isFinished;

  WordColorState({
    required this.currentIndex,
    required this.wordColors,
    required this.isFinished,
  });

  WordColorState copyWith({
    int? currentIndex,
    List<Color?>? wordColors,
    bool? isFinished,
  }) {
    return WordColorState(
      currentIndex: currentIndex ?? this.currentIndex,
      wordColors: wordColors ?? this.wordColors,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

class WordColorNotifier extends Notifier<WordColorState> {
  @override
  WordColorState build() {
    final material = ref.read(readingMaterialProvider);

    final fullText = '${material[0].title} ${material[0].content}';

    final words = fullText.split(' ');

    return WordColorState(
      currentIndex: 0,
      wordColors: List.generate(words.length, (_) => null),
      isFinished: false,
    );
  }

  void applyColor(Color color) {
    final updatedColors = [...state.wordColors];
    updatedColors[state.currentIndex] = color;

    final nextIndex = state.currentIndex + 1;
    final finished = nextIndex >= state.wordColors.length;

    state = state.copyWith(
      wordColors: updatedColors,
      currentIndex: nextIndex,
      isFinished: finished,
    );
  }

  void reset() {
    state = state.copyWith(
      currentIndex: 0,
      wordColors: List.generate(state.wordColors.length, (_) => null),
      isFinished: false,
    );
  }
}
