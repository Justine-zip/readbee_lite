import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/components/custom_reading_score_row.dart';
import 'package:readbee_lite/components/material_title_bar.dart';
import 'package:readbee_lite/components/page_title.dart';
import 'package:readbee_lite/core/utils/digital_reading_score.dart';
import 'package:readbee_lite/viewmodels/providers/evaluation_list_provider.dart';
import 'package:readbee_lite/viewmodels/providers/miscue_provider.dart';
import 'package:readbee_lite/viewmodels/providers/reading_score_provider.dart';
import 'package:readbee_lite/viewmodels/providers/selected_material_provider.dart';
import 'package:readbee_lite/viewmodels/providers/story_provider.dart';
import 'package:readbee_lite/viewmodels/providers/timer_provider.dart';
import 'package:readbee_lite/views/reading_material/digitral_comprehension_page.dart';

class MobileDigitalReadingScorePage extends ConsumerStatefulWidget {
  const MobileDigitalReadingScorePage({super.key});

  @override
  ConsumerState<MobileDigitalReadingScorePage> createState() =>
      _MobileDigitalReadingScorePageState();
}

class _MobileDigitalReadingScorePageState
    extends ConsumerState<MobileDigitalReadingScorePage> {
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
                const SizedBox(height: 30),
                const PageTitle(
                  title: 'Digital Reading Score',
                  size: 18,
                  pad: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: MaterialTitleBar(
                    name:
                        'Name: ${eval.selectedStudent?.name ?? 'None selected'}',
                    gradeSection: 'Grade & Section: ${eval.selectedSection}',

                    nameSize: 16,
                    gradeSectionSize: 16,
                    pad: 24,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 24,
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Summary of Miscue',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 30),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Type of Miscue',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Number of Miscue',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 12.0,
                                  right: 12,
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: miscues.length - 1,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          miscues[index].name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          '${miscues[index].count}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Divider(),
                              const SizedBox(height: 10),
                              storyAsync.when(
                                data: (story) {
                                  if (story == null) {
                                    return const CircularProgressIndicator();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      left: 12.0,
                                      right: 12,
                                    ),
                                    child: Column(
                                      children: [
                                        CustomReadingScoreRow(
                                          title: 'Total Miscue',
                                          value: '${totalMiscueCount(miscues)}',

                                          titleSize: 14,
                                          valueSize: 14,
                                        ),
                                        CustomReadingScoreRow(
                                          title: 'Total Number of Words',
                                          value:
                                              '${totalWords(story.content.split(RegExp(r'\s+')) + selectedMaterial.title.split(RegExp(r'\s+')))}',

                                          titleSize: 14,
                                          valueSize: 14,
                                        ),
                                        CustomReadingScoreRow(
                                          title: 'Reading Level',
                                          value: readingLevel(
                                            miscues[7].count,
                                            totalWords(
                                              story.content.split(
                                                    RegExp(r'\s+'),
                                                  ) +
                                                  selectedMaterial.title.split(
                                                    RegExp(r'\s+'),
                                                  ),
                                            ),
                                          ),

                                          titleSize: 14,
                                          valueSize: 14,
                                        ),
                                        CustomReadingScoreRow(
                                          title: 'Word per Minute',
                                          value:
                                              '${wordPerMinute(ref.read(timerProvider.notifier).elapsed.inSeconds.toDouble(), totalWords(story.content.split(RegExp(r'\s+')) + story.title.split(RegExp(r'\s+'))))}',

                                          titleSize: 14,
                                          valueSize: 14,
                                        ),
                                        CustomReadingScoreRow(
                                          title: 'Reading Speed',
                                          value: classifyReadingSpeed(
                                            wordPerMinute(
                                              ref
                                                  .read(timerProvider.notifier)
                                                  .elapsed
                                                  .inSeconds
                                                  .toDouble(),
                                              totalWords(
                                                story.content.split(
                                                      RegExp(r'\s+'),
                                                    ) +
                                                    story.title.split(
                                                      RegExp(r'\s+'),
                                                    ),
                                              ),
                                            ),
                                          ),

                                          titleSize: 14,
                                          valueSize: 14,
                                        ),
                                        CustomReadingScoreRow(
                                          title: 'Number of Correct Words',
                                          value: '${miscues[7].count}',

                                          titleSize: 14,
                                          valueSize: 14,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                loading:
                                    () => const CircularProgressIndicator(),
                                error: (e, _) => Text(e.toString()),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 120),
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
          right: 30,
          child: CustomButton(
            onTap: () {
              final miscues = ref.read(miscueProvider);
              final storyAsync = ref.read(storyProvider);
              final selectedMaterial = ref.read(selectedMaterialProvider);
              final timer = ref.read(timerProvider.notifier);

              storyAsync.whenData((story) {
                if (story == null || selectedMaterial == null) return;

                final totalWordsCount = totalWords(
                  story.content.split(RegExp(r'\s+')) +
                      selectedMaterial.title.split(RegExp(r'\s+')),
                );

                final readingScore = {
                  "miscueSummary":
                      miscues.map((m) {
                        return {"type": m.name, "count": m.count};
                      }).toList(),
                  "miscueOverallSummary": [
                    {
                      "type": "Reading Level",
                      "count": readingLevel(
                        miscues[7].count,
                        totalWords(
                          story.content.split(RegExp(r'\s+')) +
                              selectedMaterial.title.split(RegExp(r'\s+')),
                        ),
                      ),
                    },
                    {
                      "type": "Total Miscues",
                      "count": totalMiscueCount(miscues),
                    },
                    {
                      "type": "Number of Words in the Passage",
                      "count": totalWordsCount,
                    },
                    {
                      "type": "Word per Minute",
                      "count": wordPerMinute(
                        timer.elapsed.inSeconds.toDouble(),
                        totalWordsCount,
                      ),
                    },
                    {
                      "type": "Reading Speed",
                      "count": classifyReadingSpeed(
                        wordPerMinute(
                          timer.elapsed.inSeconds.toDouble(),
                          totalWordsCount,
                        ),
                      ),
                    },
                    {
                      "type": "Number of Correct Words",
                      "count": miscues[7].count,
                    },
                  ],
                };

                ref.read(readingScoreProvider.notifier).state = readingScore;

                Navigator.push(
                  context,
                  PageAnimationTransition(
                    page: const MobileDigitralComprehensionPage(),
                    pageAnimationType: RightToLeftTransition(),
                  ),
                );
              });
            },
            title: 'Proceed',
            tSize: 14,
            pad: 12,
            size: 100,
          ),
        ),
      ],
    );
  }
}

class TabletDigitalReadingScorePage extends ConsumerStatefulWidget {
  const TabletDigitalReadingScorePage({super.key});

  @override
  ConsumerState<TabletDigitalReadingScorePage> createState() =>
      _TabletDigitalReadingScorePageState();
}

class _TabletDigitalReadingScorePageState
    extends ConsumerState<TabletDigitalReadingScorePage> {
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
                const SizedBox(height: 30),
                const PageTitle(title: 'Digital Reading Score'),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: MaterialTitleBar(
                    name:
                        'Name: ${eval.selectedStudent?.name ?? 'None selected'}',
                    gradeSection: 'Grade & Section: ${eval.selectedSection}',
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 64.0),
                  child: Column(
                    children: [
                      const Text(
                        'Summary of Miscue',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Row(
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
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: miscues.length - 1,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  miscues[index].name,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  '${miscues[index].count}',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
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
                                      '${wordPerMinute(ref.read(timerProvider.notifier).elapsed.inSeconds.toDouble(), totalWords(story.content.split(RegExp(r'\s+')) + story.title.split(RegExp(r'\s+'))))}',
                                ),
                                CustomReadingScoreRow(
                                  title: 'Reading Speed',
                                  value: classifyReadingSpeed(
                                    wordPerMinute(
                                      ref
                                          .read(timerProvider.notifier)
                                          .elapsed
                                          .inSeconds
                                          .toDouble(),
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

                      const SizedBox(height: 120),
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
              final miscues = ref.read(miscueProvider);
              final storyAsync = ref.read(storyProvider);
              final selectedMaterial = ref.read(selectedMaterialProvider);
              final timer = ref.read(timerProvider.notifier);

              storyAsync.whenData((story) {
                if (story == null || selectedMaterial == null) return;

                final totalWordsCount = totalWords(
                  story.content.split(RegExp(r'\s+')) +
                      selectedMaterial.title.split(RegExp(r'\s+')),
                );

                final readingScore = {
                  "miscueSummary":
                      miscues.map((m) {
                        return {"type": m.name, "count": m.count};
                      }).toList(),
                  "miscueOverallSummary": [
                    {
                      "type": "Reading Level",
                      "count": readingLevel(
                        miscues[7].count,
                        totalWords(
                          story.content.split(RegExp(r'\s+')) +
                              selectedMaterial.title.split(RegExp(r'\s+')),
                        ),
                      ),
                    },
                    {
                      "type": "Total Miscues",
                      "count": totalMiscueCount(miscues),
                    },
                    {
                      "type": "Number of Words in the Passage",
                      "count": totalWordsCount,
                    },
                    {
                      "type": "Word per Minute",
                      "count": wordPerMinute(
                        timer.elapsed.inSeconds.toDouble(),
                        totalWordsCount,
                      ),
                    },
                    {
                      "type": "Reading Speed",
                      "count": classifyReadingSpeed(
                        wordPerMinute(
                          timer.elapsed.inSeconds.toDouble(),
                          totalWordsCount,
                        ),
                      ),
                    },
                    {
                      "type": "Number of Correct Words",
                      "count": miscues[7].count,
                    },
                  ],
                };

                ref.read(readingScoreProvider.notifier).state = readingScore;

                Navigator.push(
                  context,
                  PageAnimationTransition(
                    page: const TabletDigitralComprehensionPage(),
                    pageAnimationType: RightToLeftTransition(),
                  ),
                );
              });
            },
            title: 'Proceed',
            size: 150,
          ),
        ),
      ],
    );
  }
}
