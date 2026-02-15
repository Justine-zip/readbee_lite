import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/record_state.dart';
import 'package:readbee_lite/notifiers/record_notifier.dart';

final recordProvider = NotifierProvider<RecordNotifier, RecordState>(
  RecordNotifier.new,
);
