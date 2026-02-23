import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/providers/reading_material_provider.dart';

class WordColorState {
  final int currentIndex;
  final List<Color?> wordColors;

  WordColorState({required this.currentIndex, required this.wordColors});

  WordColorState copyWith({int? currentIndex, List<Color?>? wordColors}) {
    return WordColorState(
      currentIndex: currentIndex ?? this.currentIndex,
      wordColors: wordColors ?? this.wordColors,
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
    );
  }

  void applyColor(Color color) {
    if (state.currentIndex >= state.wordColors.length) return;

    final updatedColors = [...state.wordColors];
    updatedColors[state.currentIndex] = color;

    state = state.copyWith(
      wordColors: updatedColors,
      currentIndex: state.currentIndex + 1,
    );
  }

  void reset() {
    state = state.copyWith(
      currentIndex: 0,
      wordColors: List.generate(state.wordColors.length, (_) => null),
    );
  }
}
