import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/reading_material.dart';

final readingMaterialProvider = Provider<List<ReadingMaterial>>((ref) {
  return [
    ReadingMaterial(
      title: 'Ang Aso sa Lungga',
      content:
          'May isang asong  gutom  na gutom  na  naglalakad sa  kalsada. Habang naglalakad, ibinubulong  niya sa  sarili na kailangan niyang  makakita  ng isang lunggang puno ngpagkain.  Nang  makakita  siya  ng  lungga  sa  dulo  ng kalsada,  agad  siyang  pumasok  dito.  Kumain  siyahanggang  mabusog. Pero kahit busog na siya, kumain parin at  inubos ang  lahat  ng pagkain  sa  loob ng  lungga. Sa kanyang  kabusugan,  halos  pumutok  ang  malaki  niyang tiyan. Nang lalabas na lamang siya, napansin niyang hindi na  siya  magkasya  sa  labasan.  Sumigaw  siya  upang humingi  ng  tulong.  Dumating  ang  isa  pang  aso  at nalaman  ang  nangyari.  Bago  ito  umalis, nagwika  siya  sa kasamang  aso,  "Hintayin  mo  na  long  umimpis  ang  tiyan mo."',
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
