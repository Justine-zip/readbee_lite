import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedDay = StateProvider<DateTime>((ref) => DateTime.now());

final focusedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());
