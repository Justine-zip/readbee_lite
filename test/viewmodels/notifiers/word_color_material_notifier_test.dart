import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:readbee_lite/models/story.dart';
import 'package:readbee_lite/notifiers/word_color_material_notifier.dart';
import 'package:readbee_lite/providers/story_provider.dart';
import 'package:readbee_lite/providers/word_color_provider.dart';

void main() {
  late ProviderContainer container;
  late WordColorMaterialNotifier notifier;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        storyProvider.overrideWith(
          (ref) => Story(
            storyId: '1',
            title: 'Hello',
            content: 'World Again',
            wordCount: 3,
            language: 'English',
            gradeLevelId: '1',
            status: 'status',
            createdBy: 'createdBy',
          ),
        ),
      ],
    );

    notifier = container.read(wordColorMaterialProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('build', () {
    test('creates word color list from story words', () {
      expect(notifier.state.currentIndex, 0);
      expect(notifier.state.isFinished, false);

      // Hello World Again = 3 words
      expect(notifier.state.wordColors.length, 3);

      expect(notifier.state.wordColors, [null, null, null]);
    });
  });

  group('applyColor', () {
    test('colors current word', () {
      notifier.applyColor(Colors.red);

      expect(notifier.state.wordColors, [Colors.red, null, null]);
    });

    test('advances current index', () {
      notifier.applyColor(Colors.red);

      expect(notifier.state.currentIndex, 1);
      expect(notifier.state.isFinished, false);
    });

    test('preserves previously colored words', () {
      notifier.applyColor(Colors.red);
      notifier.applyColor(Colors.blue);

      expect(notifier.state.wordColors, [Colors.red, Colors.blue, null]);

      expect(notifier.state.currentIndex, 2);
    });

    test('marks finished on last word', () {
      notifier.applyColor(Colors.red);
      notifier.applyColor(Colors.blue);
      notifier.applyColor(Colors.green);

      expect(notifier.state.isFinished, true);
      expect(notifier.state.currentIndex, 3);

      expect(notifier.state.wordColors, [
        Colors.red,
        Colors.blue,
        Colors.green,
      ]);
    });
  });

  group('reset', () {
    test('restores initial state', () {
      notifier.applyColor(Colors.red);
      notifier.applyColor(Colors.blue);

      notifier.reset();

      expect(notifier.state.currentIndex, 0);
      expect(notifier.state.isFinished, false);

      expect(notifier.state.wordColors, [null, null, null]);
    });
  });

  group('story edge cases', () {
    test('returns empty state when story is null', () {
      final container = ProviderContainer(
        overrides: [storyProvider.overrideWith((ref) => null)],
      );

      final notifier = container.read(wordColorMaterialProvider.notifier);

      expect(notifier.state.currentIndex, 0);
      expect(notifier.state.wordColors, isEmpty);
      expect(notifier.state.isFinished, false);

      container.dispose();
    });

    test('returns empty state when loading', () {
      final completer = Completer<Story>();
      final container = ProviderContainer(
        overrides: [storyProvider.overrideWith((ref) => completer.future)],
      );

      final notifier = container.read(wordColorMaterialProvider.notifier);

      expect(notifier.state.currentIndex, 0);
      expect(notifier.state.wordColors, isEmpty);
      expect(notifier.state.isFinished, false);

      container.dispose();
    });
  });
}
