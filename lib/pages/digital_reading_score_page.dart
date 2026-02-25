import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/components/custom_reading_score_row.dart';
import 'package:readbee_lite/components/title_bar.dart';
import 'package:readbee_lite/core/utils/digital_reading_score.dart';
import 'package:readbee_lite/pages/digitral_comprehension_page.dart';
import 'package:readbee_lite/providers/miscue_provider.dart';
import 'package:readbee_lite/providers/reading_material_provider.dart';

class DigitalReadingScorePage extends ConsumerStatefulWidget {
  const DigitalReadingScorePage({super.key});

  @override
  ConsumerState<DigitalReadingScorePage> createState() =>
      _DigitalReadingScorePageState();
}

class _DigitalReadingScorePageState
    extends ConsumerState<DigitalReadingScorePage> {
  @override
  Widget build(BuildContext context) {
    final miscues = ref.watch(miscueProvider);
    final material = ref.watch(readingMaterialProvider);
    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: TitleBar(
                    title: 'Student Name Sample',
                    description: 'description',
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 64.0),
                  child: Column(
                    children: [
                      Text(
                        'Summary of Miscue',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Type of Miscue',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Number of Miscue',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 100),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: miscues.length - 1,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  miscues[index].name,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  '${miscues[index].count}',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 100),
                        child: Column(
                          children: [
                            CustomReadingScoreRow(
                              title: 'Total Miscue',
                              value: '${totalMiscueCount(miscues)}',
                            ),
                            CustomReadingScoreRow(
                              title: 'Number of Words in the Passage',
                              value:
                                  '${totalWords(material[0].content.split(' ') + material[0].title.split(' '))}',
                            ),
                            CustomReadingScoreRow(
                              title: 'Reading Level',
                              value:
                                  '${totalWords(material[0].content.split(' '))}',
                            ),
                            CustomReadingScoreRow(
                              title: 'Word per Minute',
                              value:
                                  '${totalWords(material[0].content.split(' '))}',
                            ),
                            CustomReadingScoreRow(
                              title: 'Reading Speed',
                              value:
                                  '${totalWords(material[0].content.split(' '))}',
                            ),
                            CustomReadingScoreRow(
                              title: 'Number of Correct Words',
                              value: '${miscues[7].count}',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        //Proceed Button
        Positioned(
          bottom: 50,
          right: 50,
          child: CustomButton(
            onTap: () {
              Navigator.push(
                context,
                PageAnimationTransition(
                  page: DigitralComprehensionPage(),
                  pageAnimationType: RightToLeftTransition(),
                ),
              );
            },
            title: 'Proceed',
            size: 150,
          ),
        ),
      ],
    );
  }
}
