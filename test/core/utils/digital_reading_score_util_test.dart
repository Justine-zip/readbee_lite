import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:readbee_lite/core/utils/digital_reading_score.dart';
import 'package:readbee_lite/models/miscue.dart';

void main() {
  test('totalMiscueCount value test', () {
    expect(
      totalMiscueCount([
        Miscue(name: 'Substitution', count: 2, color: Colors.red),
        Miscue(name: 'Repetition', count: 5, color: Colors.grey),
        Miscue(name: 'Omission', count: 0, color: Colors.purple),
      ]),
      7,
    );
  });

  test('totalWords value test', () {
    expect(totalWords(['sample', 'test', 'total']), 3);
    expect(totalWords(['sample', 'test']), 2);
    expect(totalWords(['sample', 'test', 'total', 'words', 'readbee']), 5);
  });

  test('readingLevel value test', () {
    expect(
      readingLevel(
        3,
        totalWords(['sample', 'test', 'total', 'words', 'readbee']),
      ),
      'Frustration',
    );
    expect(
      readingLevel(
        5,
        totalWords(['sample', 'test', 'total', 'words', 'readbee']),
      ),
      'Independent',
    );
  });

  test('wordPerMinute value test', () {
    expect(wordPerMinute(12, 25), 125);
    expect(wordPerMinute(6, 30), 300);
    expect(wordPerMinute(18, 36), 120);
  });

  test('classifyReadingSpeed value test', () {
    expect(classifyReadingSpeed(wordPerMinute(12, 25)), 'Fast');
    expect(classifyReadingSpeed(wordPerMinute(15, 25)), 'Average');
    expect(classifyReadingSpeed(wordPerMinute(20, 25)), 'Slow');
    expect(classifyReadingSpeed(wordPerMinute(31, 25)), 'Struggling');
    expect(classifyReadingSpeed(0), 'Non-reader');
  });
}
