import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedDay = StateProvider<DateTime>((ref) => DateTime.now());
