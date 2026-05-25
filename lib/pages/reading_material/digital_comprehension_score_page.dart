import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/components/comprehension_score_box.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/components/material_title_bar.dart';
import 'package:readbee_lite/components/page_title.dart';
import 'package:readbee_lite/core/services/assessment_record_service.dart';
import 'package:readbee_lite/core/utils/digital_comprehension_score.dart';
import 'package:readbee_lite/layouts/main_layout.dart';
import 'package:readbee_lite/providers/assignment.dart';
import 'package:readbee_lite/providers/comprehension_provider.dart';
import 'package:readbee_lite/providers/evaluation_list_provider.dart';
import 'package:readbee_lite/providers/quiz_question_provider.dart';
import 'package:readbee_lite/providers/reading_score_provider.dart';
import 'package:readbee_lite/providers/selected_material_provider.dart';
import 'package:readbee_lite/providers/word_color_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    final questionAsync = ref.watch(quizQuestionProvider);
    if (selectedMaterial == null) {
      return const CircularProgressIndicator();
    }
    final eval = ref.watch(evaluationProvider);

    final compState = ref.watch(comprehensionProvider);
    final answerKey = ref.watch(wordColorComprehensionProvider).key;

    return questionAsync.when(
      data: (questions) {
        final totalQuestions = questions.length;

        final correct = totalCorrect(
          selectedAnswers: compState.selectedAnswers,
          choices:
              questions
                  .map((q) => q.choices.map((c) => c.choice).toList())
                  .toList(),
          answerKey: answerKey,
        );

        final wrong = totalWrong(
          totalQuestions: totalQuestions,
          totalCorrect: correct,
        );

        final rate = comprehensionRate(totalQuestions, correct);
        final level = comprehensionLevel(correct);
        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            ref.read(comprehensionProvider.notifier).resetFinished();
          },
          child: Stack(
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
                          gradeSection:
                              'Grade & Section: ${eval.selectedSection}',
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ComprehensionScoreBox(
                                        value: level,
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
                                height:
                                    MediaQuery.of(context).size.height * .675,
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: questions.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  questions[index].questionText,
                                                  style: TextStyle(
                                                    fontSize: 26,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    12.0,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      for (final entry
                                                          in questions[index]
                                                              .choices
                                                              .asMap()
                                                              .entries)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 4,
                                                              ),
                                                          child: Builder(
                                                            builder: (context) {
                                                              final choiceIndex =
                                                                  entry.key;
                                                              final choiceValue =
                                                                  entry
                                                                      .value
                                                                      .choice;

                                                              final correctLetter =
                                                                  String.fromCharCode(
                                                                    65 +
                                                                        questions[index]
                                                                            .correctAnswer,
                                                                  );

                                                              final userAnswer =
                                                                  compState
                                                                      .selectedAnswers[index];

                                                              final choiceLetter =
                                                                  String.fromCharCode(
                                                                    65 +
                                                                        choiceIndex,
                                                                  );

                                                              Color textColor =
                                                                  Colors.black;

                                                              if (userAnswer !=
                                                                  null) {
                                                                if (choiceLetter ==
                                                                    correctLetter) {
                                                                  textColor =
                                                                      Colors
                                                                          .green;
                                                                } else if (choiceLetter ==
                                                                    userAnswer) {
                                                                  textColor =
                                                                      Colors
                                                                          .red;
                                                                }
                                                              }

                                                              return Text(
                                                                "${String.fromCharCode(65 + choiceIndex)}. $choiceValue",
                                                                style: TextStyle(
                                                                  fontSize: 22,
                                                                  color:
                                                                      textColor,
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                          padding: const EdgeInsets.only(
                                            bottom: 50,
                                          ),
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
                  onTap: () async {
                    try {
                      final supabase = Supabase.instance.client;
                      final userId = supabase.auth.currentUser!.id;

                      final selectedStudent = eval.selectedStudent;
                      final material = ref.read(selectedMaterialProvider);

                      final readingScore = ref.watch(readingScoreProvider);
                      final assignment = ref.read(assignmentProvider).value;

                      if (selectedStudent == null ||
                          material == null ||
                          readingScore == null ||
                          assignment == null) {
                        return;
                      }

                      final readingLevel =
                          (readingScore['miscueOverallSummary'] as List?)
                              ?.firstWhere(
                                (item) => item['type'] == 'Reading Level',
                                orElse: () => {'count': 'Unknown'},
                              )['count'];

                      final comprehensionScore = {
                        // "answerSummary": compState.answerSummary,
                        "comprehensionSummary": [
                          {"type": "No. of Correct Answer", "count": correct},
                          {"type": "No. of Wrong Answer", "count": wrong},
                          {"type": "Comprehension Score", "count": level},
                          {"type": "Comprehension Rate", "count": rate},
                        ],
                      };

                      final totalScore = rate;

                      await AssessmentRecordService().insertAssessmentRecord(
                        pupilId: selectedStudent.studentId,
                        evaluatorUserId: userId,
                        materialId: material.materialId,
                        scheduleId: assignment.scheduleId,
                        assignmentId: assignment.assignmentId,
                        yearId: assignment.yearId,
                        quarterId: assignment.quarterId,
                        assessmentMethod: 'Digital',
                        assessmentType: 'Comprehension',
                        readingScore: readingScore,
                        comprehensionScore: comprehensionScore,
                        totalScore: totalScore,
                        readingLevel: readingLevel,
                        miscueContent: '',
                      );

                      if (!mounted) return;

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return Dialog(
                            child: Container(
                              width: 400,
                              height: 250,
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Center(
                                  child: Text(
                                    'Congratulations for finishing the evaluation!',
                                    style: TextStyle(fontSize: 22),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );

                      Future.delayed(const Duration(seconds: 3), () {
                        Navigator.pop(context);

                        Navigator.push(
                          context,
                          PageAnimationTransition(
                            page: TabletMainLayout(initialIndex: 2),
                            pageAnimationType: RightToLeftTransition(),
                          ),
                        );
                      });
                    } catch (e) {
                      debugPrint(e.toString());

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to save assessment record'),
                        ),
                      );
                    }
                  },
                  title: 'Proceed',
                  size: 200,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text(e.toString()),
    );
  }
}
