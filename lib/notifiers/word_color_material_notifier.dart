import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/providers/story_provider.dart';
import 'package:readbee_lite/providers/timer_provider.dart';

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

class WordColorMaterialNotifier
    extends AutoDisposeNotifier<WordColorMaterialState> {
  @override
  WordColorMaterialState build() {
    final storyAsync = ref.watch(storyProvider);

    return storyAsync.when(
      data: (story) {
        if (story == null) {
          return WordColorMaterialState(
            currentIndex: 0,
            wordColors: [],
            isFinished: false,
          );
        }

        final fullText = '${story.title} ${story.content}';
        final words = fullText.split(RegExp(r'\s+'));

        return WordColorMaterialState(
          currentIndex: 0,
          wordColors: List.generate(words.length, (_) => null),
          isFinished: false,
        );
      },

      loading:
          () => WordColorMaterialState(
            currentIndex: 0,
            wordColors: [],
            isFinished: false,
          ),

      error:
          (_, __) => WordColorMaterialState(
            currentIndex: 0,
            wordColors: [],
            isFinished: false,
          ),
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

    if (finished) {
      ref.read(timerProvider.notifier).stop();
      debugPrint('TimeElapsed: ${ref.read(timerProvider.notifier).elapsed}');
    }
  }

  void reset() {
    state = state.copyWith(
      currentIndex: 0,
      wordColors: List.generate(state.wordColors.length, (_) => null),
      isFinished: false,
    );
  }
}
