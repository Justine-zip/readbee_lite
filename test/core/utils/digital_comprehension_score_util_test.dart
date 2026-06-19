import 'package:flutter_test/flutter_test.dart';
import 'package:readbee_lite/core/utils/digital_comprehension_score.dart';

void main() {
  test('comprehension level value test', () {
    expect(comprehensionLevel(3), 'Instructional');
    expect(comprehensionLevel(1), 'Frustration');
    expect(comprehensionLevel(5), 'Independent');
  });

  test('comprehension rate value test', () {
    expect(comprehensionRate(10, 8), 80);
    expect(comprehensionRate(5, 3), 60);
    expect(comprehensionRate(30, 24), 80);
  });

  test('totalCorrect value test', () {
    expect(
      totalCorrect(
        selectedAnswers: {0: 'A', 1: 'A', 2: 'B'},
        choices: [
          ['sub1', 'sub2', 'sub3'],
          ['sub11', 'sub12', 'sub13'],
          ['sub21', 'sub22', 'sub23'],
        ],
        answerKey: [0, 1, 1],
      ),
      2,
    );
    expect(
      totalCorrect(
        selectedAnswers: {0: 'A', 1: 'B', 2: 'B'},
        choices: [
          ['sub1', 'sub2', 'sub3'],
          ['sub11', 'sub12', 'sub13'],
          ['sub21', 'sub22', 'sub23'],
        ],
        answerKey: [0, 1, 1],
      ),
      3,
    );
  });

  test('totalWrong value test', () {
    expect(
      totalWrong(
        totalQuestions: 3,
        totalCorrect: totalCorrect(
          selectedAnswers: {0: 'A', 1: 'B', 2: 'B'},
          choices: [
            ['sub1', 'sub2', 'sub3'],
            ['sub11', 'sub12', 'sub13'],
            ['sub21', 'sub22', 'sub23'],
          ],
          answerKey: [0, 1, 1],
        ),
      ),
      0,
    );
    expect(
      totalWrong(
        totalQuestions: 3,
        totalCorrect: totalCorrect(
          selectedAnswers: {0: 'A', 1: 'A', 2: 'A'},
          choices: [
            ['sub1', 'sub2', 'sub3'],
            ['sub11', 'sub12', 'sub13'],
            ['sub21', 'sub22', 'sub23'],
          ],
          answerKey: [0, 1, 1],
        ),
      ),
      2,
    );
  });
}
