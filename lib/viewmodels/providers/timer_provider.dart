import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/viewmodels/notifiers/timer_notifier.dart';

final timerProvider = StateNotifierProvider<TimerNotifier, int>((ref) {
  return TimerNotifier(ref);
});

final timerStartedProvider = StateProvider<bool>((ref) => false);
