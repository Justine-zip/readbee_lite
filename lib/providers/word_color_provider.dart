import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/notifiers/word_color_notifier.dart';

final wordColorProvider = NotifierProvider<WordColorNotifier, List<Color?>>(
  WordColorNotifier.new,
);
