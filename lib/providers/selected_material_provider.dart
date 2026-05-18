import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/reading_material.dart';

final selectedMaterialProvider = StateProvider<ReadingMaterial?>((ref) => null);
