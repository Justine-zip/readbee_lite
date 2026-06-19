import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/viewmodels/notifiers/word_color_comprehension_notifier.dart';
import 'package:readbee_lite/viewmodels/notifiers/word_color_material_notifier.dart';

final wordColorMaterialProvider = NotifierProvider.autoDispose<
  WordColorMaterialNotifier,
  WordColorMaterialState
>(WordColorMaterialNotifier.new);

final wordColorComprehensionProvider = NotifierProvider<
  WordColorComprehensionNotifier,
  WordColorComprehensionState
>(WordColorComprehensionNotifier.new);
