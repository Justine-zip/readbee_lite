import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/section.dart';

final sectionProvider = Provider<List<Section>>((ref) {
  return [
    Section(section: 'Sampaguita', sectionId: 'sec_a'),
    Section(section: 'Tulips', sectionId: 'sec_b'),
    Section(section: 'Rosas', sectionId: 'sec_c'),
    Section(section: 'Menudo', sectionId: 'sec_d'),
  ];
});
