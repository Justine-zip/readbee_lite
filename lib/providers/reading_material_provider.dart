import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/reading_material.dart';

final readingMaterialProvider = Provider<List<ReadingMaterial>>((ref) {
  return [
    ReadingMaterial(
      title: 'Ang Aso sa Lungga',
      content:
          'May isang asong  gutom  na gutom  na  naglalakadsa  kalsada. Habang naglalakad, ibinubulong  niya sa  sarilina kailangan niyang  makakita  ng isang lunggang puno ngpagkain.  Nang  makakita  siya  ng  lungga  sa  dulo  ngkalsada,  agad  siyang  pumasok  dito.  Kumain  siyahanggang  mabusog. Pero kahit busog na siya, kumain parin at  inubos ang  lahat  ng pagkain  sa  loob ng  lungga. Sakanyang  kabusugan,  halos  pumutok  ang  malaki  niyangtiyan. Nang lalabas na lamang siya, napansin niyang hindina  siya  magkasya  sa  labasan.  Sumigaw  siya  upanghumingi  ng  tulong.  Dumating  ang  isa  pang  aso  atnalaman  ang  nangyari.  Bago  ito  umalis, nagwika  siya  sakasamang  aso,  "Hintayin  mo  na  long  umimpis  ang  tiyanmo."',
      language: 'Tagalog',
      question: [
        'Saan  nangyari  ang  kuwento?',
        'Ano ang hinahanap ng aso?',
        'Anong ugali ang ipinakita ng aso?',
        'Bakit hindi makalabas ang aso so lungga?',
        'Bakit kayo hindi siya natulungan ng isa pang aso?',
      ],
      key: [
        ['bukid', 'gubat', 'kalsada', 'lansangan'],
        ['makakain', 'makakasama', 'mapapasyalan', 'matutulugan'],
        ['madamot', 'matakaw', 'masipag', 'mayabang'],
        [
          'may harang ang labasan',
          'may bitbit pa siyang  pagkain',
          'lubos no  marami  ang  kinain niya',
          'mali ang paraan ng paglabas niya',
        ],
        [
          'natakot sa kanya ang aso',
          'para matuto siya sa pangyayari',
          'nainggit sa kanya ang isa pang aso',
          'hindi rin ito makakalabas sa lungga',
        ],
      ],
      wordLength: 47,
      storyId: 1,
      quizId: 1,
    ),
  ];
});
