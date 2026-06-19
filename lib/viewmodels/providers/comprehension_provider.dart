import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/viewmodels/notifiers/comprehension_notifier.dart';

final comprehensionProvider = StateNotifierProvider.autoDispose<
  ComprehensionNotifier,
  ComprehensionState
>((ref) => ComprehensionNotifier());
