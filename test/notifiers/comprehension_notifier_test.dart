import 'package:flutter_test/flutter_test.dart';
import 'package:readbee_lite/notifiers/comprehension_notifier.dart';

void main() {
  late ComprehensionNotifier notifier;

  setUp(() {
    notifier = ComprehensionNotifier();
  });

  group('ComprehensionNotifier', () {
    test('initial state', () {
      expect(notifier.state.currentQuestionIndex, 0);
      expect(notifier.state.selectedAnswers, {});
      expect(notifier.state.isFinished, false);
    });

    test('selectAnswer advances to next question', () {
      notifier.selectAnswer(totalQuestions: 3, answer: 'A');

      expect(notifier.state.currentQuestionIndex, 1);
      expect(notifier.state.selectedAnswers, {0: 'A'});
      expect(notifier.state.isFinished, false);
    });

    test('selectAnswer marks finished on last question', () {
      notifier.selectAnswer(totalQuestions: 2, answer: 'A');

      notifier.selectAnswer(totalQuestions: 2, answer: 'B');

      expect(notifier.state.currentQuestionIndex, 1);
      expect(notifier.state.selectedAnswers, {0: 'A', 1: 'B'});
      expect(notifier.state.isFinished, true);
    });

    test('undoAnswer goes back one question', () {
      notifier.selectAnswer(totalQuestions: 3, answer: 'A');

      notifier.selectAnswer(totalQuestions: 3, answer: 'B');

      notifier.undoAnswer();

      expect(notifier.state.currentQuestionIndex, 1);
      expect(notifier.state.selectedAnswers, {0: 'A'});
      expect(notifier.state.isFinished, false);
    });

    test('undoAnswer does nothing on first question', () {
      notifier.undoAnswer();

      expect(notifier.state.currentQuestionIndex, 0);
      expect(notifier.state.selectedAnswers, {});
      expect(notifier.state.isFinished, false);
    });

    test('reset restores initial state', () {
      notifier.selectAnswer(totalQuestions: 3, answer: 'A');

      notifier.reset();

      expect(notifier.state.currentQuestionIndex, 0);
      expect(notifier.state.selectedAnswers, {});
      expect(notifier.state.isFinished, false);
    });

    test('resetFinished sets isFinished to false', () {
      notifier.selectAnswer(totalQuestions: 1, answer: 'A');

      expect(notifier.state.isFinished, true);

      notifier.resetFinished();

      expect(notifier.state.isFinished, false);
    });
  });
}
