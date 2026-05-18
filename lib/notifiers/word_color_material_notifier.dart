import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/providers/selected_material_provider.dart';

class WordColorMaterialState {
  final int currentIndex;
  final List<Color?> wordColors;
  final bool isFinished;

  WordColorMaterialState({
    required this.currentIndex,
    required this.wordColors,
    required this.isFinished,
  });

  WordColorMaterialState copyWith({
    int? currentIndex,
    List<Color?>? wordColors,
    bool? isFinished,
  }) {
    return WordColorMaterialState(
      currentIndex: currentIndex ?? this.currentIndex,
      wordColors: wordColors ?? this.wordColors,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

class WordColorMaterialNotifier extends Notifier<WordColorMaterialState> {
  @override
  WordColorMaterialState build() {
    final selectedMaterial = ref.watch(selectedMaterialProvider);

    final fullText = '${selectedMaterial?.title} ${selectedMaterial?.content}';

    final words = fullText.split(' ');

    return WordColorMaterialState(
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
