import 'package:flutter/material.dart';
import 'package:readbee_lite/components/custom_textfield.dart';
import 'package:readbee_lite/components/filter_sheet.dart';
import 'package:readbee_lite/components/reading_material_builder.dart';
import 'package:readbee_lite/components/title_bar.dart';
import 'package:readbee_lite/models/reading_material.dart';

class MobileReadingMaterialPage extends StatefulWidget {
  const MobileReadingMaterialPage({super.key});

  @override
  State<MobileReadingMaterialPage> createState() =>
      _MobileReadingMaterialPageState();
}

class _MobileReadingMaterialPageState extends State<MobileReadingMaterialPage> {
  DraggableScrollableController controller = DraggableScrollableController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            const Text(
              'Reading Materials',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomTextfield(hint: 'Search...'),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return FilterSheet(textSize: 1, sheetSize: .4);
                      },
                    );
                  },
                  icon: const Icon(Icons.filter_alt_rounded),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                itemCount: 12,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            debugPrint('Book $index');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      Text('Book $index', textAlign: TextAlign.center),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabletReadingMaterialPage extends StatefulWidget {
  const TabletReadingMaterialPage({super.key});

  @override
  State<TabletReadingMaterialPage> createState() =>
      _TabletReadingMaterialPageState();
}

class _TabletReadingMaterialPageState extends State<TabletReadingMaterialPage> {
  DraggableScrollableController controller = DraggableScrollableController();
  List<ReadingMaterial> material = [
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            TitleBar(
              title: 'Reading Materials',
              description:
                  'Select reading materials to assess students, ensuring accurate and organized evaluation of tjeir reading skills',
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomTextfield(hint: 'Search...'),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return FilterSheet(textSize: 1.25, sheetSize: .45);
                      },
                    );
                  },
                  icon: const Icon(Icons.filter_alt_rounded),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ReadingMaterialBuilder(material: material),
          ],
        ),
      ),
    );
  }
}
