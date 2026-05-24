import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/components/custom_reading_score_row.dart';
import 'package:readbee_lite/components/material_title_bar.dart';
import 'package:readbee_lite/components/page_title.dart';
import 'package:readbee_lite/core/utils/digital_reading_score.dart';
import 'package:readbee_lite/pages/reading_material/digitral_comprehension_page.dart';
import 'package:readbee_lite/providers/evaluation_list_provider.dart';
import 'package:readbee_lite/providers/miscue_provider.dart';
import 'package:readbee_lite/providers/selected_material_provider.dart';
import 'package:readbee_lite/providers/story_provider.dart';

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
    final eval = ref.watch(evaluationProvider);
    final miscues = ref.watch(miscueProvider);
    final selectedMaterial = ref.watch(selectedMaterialProvider);
    final storyAsync = ref.watch(storyProvider);

    if (selectedMaterial == null) {
      return const CircularProgressIndicator();
    }
    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),
                PageTitle(title: 'Digital Reading Score'),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: MaterialTitleBar(
                    name:
                        'Name: ${eval.selectedStudent?.name ?? 'None selected'}',
                    gradeSection: 'Grade & Section: ${eval.selectedSection}',
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
                      storyAsync.when(
                        data: (story) {
                          if (story == null) {
                            return const CircularProgressIndicator();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 24.0,
                              right: 100,
                            ),
                            child: Column(
                              children: [
                                CustomReadingScoreRow(
                                  title: 'Total Miscue',
                                  value: '${totalMiscueCount(miscues)}',
                                ),
                                CustomReadingScoreRow(
                                  title: 'Number of Words in the Passage',
                                  value:
                                      '${totalWords(story.content.split(RegExp(r'\s+')) + selectedMaterial.title.split(RegExp(r'\s+')))}',
                                ),
                                CustomReadingScoreRow(
                                  title: 'Reading Level',
                                  value: readingLevel(
                                    miscues[7].count,
                                    totalWords(
                                      story.content.split(RegExp(r'\s+')) +
                                          selectedMaterial.title.split(
                                            RegExp(r'\s+'),
                                          ),
                                    ),
                                  ),
                                ),
                                CustomReadingScoreRow(
                                  title: 'Word per Minute',
                                  value:
                                      '${wordPerMinute(50, totalWords(story.content.split(RegExp(r'\s+')) + story.title.split(RegExp(r'\s+'))))}',
                                ),
                                CustomReadingScoreRow(
                                  title: 'Reading Speed',
                                  value: classifyReadingSpeed(
                                    wordPerMinute(
                                      50,
                                      totalWords(
                                        story.content.split(RegExp(r'\s+')) +
                                            story.title.split(RegExp(r'\s+')),
                                      ),
                                    ),
                                  ),
                                ),
                                CustomReadingScoreRow(
                                  title: 'Number of Correct Words',
                                  value: '${miscues[7].count}',
                                ),
                              ],
                            ),
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (e, _) => Text(e.toString()),
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
