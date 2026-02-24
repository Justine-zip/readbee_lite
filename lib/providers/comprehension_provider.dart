import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/notifiers/comprehension_notifier.dart';

final comprehensionProvider =
    StateNotifierProvider<ComprehensionNotifier, ComprehensionState>(
      (ref) => ComprehensionNotifier(),
    );
