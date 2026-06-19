import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/viewmodels/notifiers/evaluation_list_notifier.dart';

final evaluationProvider =
    NotifierProvider<EvaluationNotifier, EvaluationState>(
      EvaluationNotifier.new,
    );
