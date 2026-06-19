import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:readbee_lite/notifiers/miscue_notifier.dart';
import 'package:readbee_lite/providers/miscue_provider.dart';

void main() {
  late ProviderContainer container;
  late MiscueNotifier notifier;

  setUp(() {
    container = ProviderContainer();
    notifier = container.read(miscueProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  test('initial miscues have count 0', () {
    expect(notifier.state.length, 8);

    for (final miscue in notifier.state) {
      expect(miscue.count, 0);
    }
  });

  test('increment increases count of selected miscue', () {
    notifier.increment(0);

    expect(notifier.state[0].count, 1);
  });

  test('increment only affects selected miscue', () {
    notifier.increment(2);

    expect(notifier.state[2].count, 1);

    for (int i = 0; i < notifier.state.length; i++) {
      if (i != 2) {
        expect(notifier.state[i].count, 0);
      }
    }
  });

  test('multiple increments accumulate correctly', () {
    notifier.increment(0);
    notifier.increment(0);
    notifier.increment(0);

    expect(notifier.state[0].count, 3);
  });

  test('reset sets all counts to 0', () {
    notifier.increment(0);
    notifier.increment(1);
    notifier.increment(2);

    notifier.reset();

    for (final miscue in notifier.state) {
      expect(miscue.count, 0);
    }
  });
}
