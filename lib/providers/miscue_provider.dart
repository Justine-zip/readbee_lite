import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/miscue.dart';
import 'package:readbee_lite/notifiers/miscue_notifier.dart';

final miscueProvider = NotifierProvider<MiscueNotifier, List<Miscue>>(
  MiscueNotifier.new,
);
