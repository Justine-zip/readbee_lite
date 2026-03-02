import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/components/comprehension_score_box.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/components/material_title_bar.dart';
import 'package:readbee_lite/components/page_title.dart';
import 'package:readbee_lite/core/utils/digital_comprehension_score.dart';
import 'package:readbee_lite/pages/reading_material_page.dart';
import 'package:readbee_lite/providers/comprehension_provider.dart';
import 'package:readbee_lite/providers/evaluation_list_provider.dart';
import 'package:readbee_lite/providers/selected_material_provider.dart';
import 'package:readbee_lite/providers/word_color_provider.dart';

class DigitalComprehensionScorePage extends ConsumerStatefulWidget {
  const DigitalComprehensionScorePage({super.key});

  @override
  ConsumerState<DigitalComprehensionScorePage> createState() =>
      _DigitalComprehensionScorePageState();
}

class _DigitalComprehensionScorePageState
    extends ConsumerState<DigitalComprehensionScorePage> {
  @override
  Widget build(BuildContext context) {
    final selectedMaterial = ref.watch(selectedMaterialProvider);
    if (selectedMaterial == null) {
      return const CircularProgressIndicator();
    }
    final eval = ref.watch(evaluationProvider);

    final compState = ref.watch(comprehensionProvider);
    final answerKey = ref.watch(wordColorComprehensionProvider).key;

    final totalQuestions = selectedMaterial.question.length;

    final correct = totalCorrect(
      selectedAnswers: compState.selectedAnswers,
      choices: selectedMaterial.choice,
      answerKey: answerKey,
    );

    final wrong = totalWrong(
      totalQuestions: totalQuestions,
      totalCorrect: correct,
    );

    final rate = comprehensionRate(totalQuestions, correct);
    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),

                PageTitle(title: 'Digital Comprehension'),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: MaterialTitleBar(
                    name:
                        'Name: ${eval.selectedStudent?.name ?? 'None selected'}',
                    gradeSection: 'Grade & Section: ${eval.selectedSection}',
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ComprehensionScoreBox(
                                  value: '$correct',
                                  subtitle: 'No. of Correct Answer',
                                ),
                                ComprehensionScoreBox(
                                  value: '$wrong',
                                  subtitle: 'No. of Wrong Answer',
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ComprehensionScoreBox(
                                  value: 'Instructional',
                                  subtitle: 'Comprehension Level',
                                ),
                                ComprehensionScoreBox(
                                  value: '${rate.toStringAsFixed(0)}%',
                                  subtitle: 'Comprehension Rate',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Material(
                        elevation: 3,
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * .675,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: selectedMaterial.question.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            selectedMaterial.question[index],
                                            style: TextStyle(fontSize: 26),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                for (var choice
                                                    in selectedMaterial
                                                        .choice[index]
                                                        .asMap()
                                                        .entries)
                                                  Consumer(
                                                    builder: (context, ref, _) {
                                                      final state = ref.watch(
                                                        wordColorComprehensionProvider,
                                                      );
                                                      final answer = ref.watch(
                                                        comprehensionProvider,
                                                      );

                                                      final correctAnswer =
                                                          state.key[index];
                                                      final studentAnswerValue =
                                                          answer
                                                              .selectedAnswers[index];

                                                      final currentChoiceValue =
                                                          choice.value;

                                                      Color textColor =
                                                          Colors.black;

                                                      if (studentAnswerValue !=
                                                          null) {
                                                        if (studentAnswerValue ==
                                                            selectedMaterial
                                                                .choice[index][correctAnswer]) {
                                                          if (currentChoiceValue ==
                                                              selectedMaterial
                                                                  .choice[index][correctAnswer]) {
                                                            textColor =
                                                                Colors.green;
                                                          }
                                                        } else {
                                                          if (currentChoiceValue ==
                                                              selectedMaterial
                                                                  .choice[index][correctAnswer]) {
                                                            textColor =
                                                                Colors.green;
                                                          }
                                                          if (currentChoiceValue ==
                                                              studentAnswerValue) {
                                                            textColor =
                                                                Colors.red;
                                                          }
                                                        }
                                                      }

                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 4,
                                                            ),
                                                        child: Text(
                                                          "${String.fromCharCode(65 + choice.key)}. $currentChoiceValue",
                                                          style: TextStyle(
                                                            fontSize: 22,
                                                            color: textColor,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    padding: const EdgeInsets.only(bottom: 50),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60),
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
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return Dialog(
                    child: Container(
                      width: 400,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: Text(
                            'Congratulations for finishing the evaluation!',
                            style: const TextStyle(fontSize: 22),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );

              if (mounted) {
                Future.delayed(const Duration(seconds: 3), () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageAnimationTransition(
                      page: TabletReadingMaterialPage(),
                      pageAnimationType: RightToLeftTransition(),
                    ),
                  );
                });
              }
            },
            title: 'Proceed',
            size: 200,
          ),
        ),
      ],
    );
  }
}
