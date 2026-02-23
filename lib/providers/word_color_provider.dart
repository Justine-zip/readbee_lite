import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/notifiers/word_color_notifier.dart';

final wordColorProvider = NotifierProvider<WordColorNotifier, WordColorState>(
  WordColorNotifier.new,
);
