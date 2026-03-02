import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/models/reading_material.dart';

final readingMaterialProvider = Provider<List<ReadingMaterial>>((ref) {
  return [
    ReadingMaterial(
      title: 'Ang Aso sa Lungga',
      content: 'May isang asong gutom na gutom na naglalakad sa kalsada.',
      language: 'Tagalog',
      question: [
        'Saan nangyari ang kuwento?',
        'Ano ang hinahanap ng aso?',
        'Anong ugali ang ipinakita ng aso?',
        'Bakit hindi makalabas ang aso so lungga?',
        'Bakit kayo hindi siya natulungan ng isa pang aso?',
      ],
      choice: [
        ['bukid', 'gubat', 'kalsada', 'lansangan'],
        ['makakain', 'makakasama', 'mapapasyalan', 'matutulugan'],
        ['madamot', 'matakaw', 'masipag', 'mayabang'],
        [
          'may harang ang labasan',
          'may bitbit pa siyang pagkain',
          'lubos no marami ang kinain niya',
          'mali ang paraan ng paglabas niya',
        ],
        [
          'natakot sa kanya ang aso',
          'para matuto siya sa pangyayari',
          'nainggit sa kanya ang isa pang aso',
          'hindi rin ito makakalabas sa lungga',
        ],
      ],
      key: [2, 0, 1, 2, 1],
      wordLength: 47,
      storyId: 1,
      quizId: 1,
    ),
    ReadingMaterial(
      title: 'Ang Loro ni Lolo Kiko',
      content: 'May loro si Lolo Kiko. Nagsasalita ang loro ni Lolo.',
      language: 'Tagalog',
      question: [
        'Ano ang alaga ni Lolo Kiko? (Literal)',
        'Ano ang paborito ng alaga ni Lolo? (Literal)',
        'Ano kaya ang naramdaman ni Lolo nang mawala ang loro? (Paghinuha)',
        'Saan kaya naganap ang kuwento? (Paghinuha)',
        'Ano ang isa pang magandang pamagat sa kuwento? (Pagsusuri)',
      ],
      choice: [
        ['aso', 'loro', 'pusa'],
        ['makalipad sa puno', 'makatikim ng keso', 'makausap si Lolo Kiko'],
        ['masaya', 'malungkot', 'nagalit'],
        ['bahay', 'gubat', 'paaralan'],
        ['Si Lolo Kiko', 'Ang Loro sa Puno', 'Ang Alagang Loro'],
      ],
      key: [1, 1, 1, 0, 2],
      wordLength: 29,
      storyId: 2,
      quizId: 2,
    ),
  ];
});
