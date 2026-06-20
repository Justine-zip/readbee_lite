import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/components/comprehension_score_box.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/components/material_title_bar.dart';
import 'package:readbee_lite/components/page_title.dart';
import 'package:readbee_lite/components/show_global_snack_bar.dart';
import 'package:readbee_lite/core/layouts/main_layout.dart';
import 'package:readbee_lite/core/services/assessment_record_service.dart';
import 'package:readbee_lite/core/utils/digital_comprehension_score.dart';
import 'package:readbee_lite/viewmodels/providers/assessment_record_provider.dart';
import 'package:readbee_lite/viewmodels/providers/assignment_provider.dart';
import 'package:readbee_lite/viewmodels/providers/comprehension_provider.dart';
import 'package:readbee_lite/viewmodels/providers/evaluation_list_provider.dart';
import 'package:readbee_lite/viewmodels/providers/miscue_content_provider.dart';
import 'package:readbee_lite/viewmodels/providers/quiz_question_provider.dart';
import 'package:readbee_lite/viewmodels/providers/reading_score_provider.dart';
import 'package:readbee_lite/viewmodels/providers/selected_material_provider.dart';
import 'package:readbee_lite/viewmodels/providers/word_color_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MobileDigitalComprehensionScorePage extends ConsumerStatefulWidget {
  const MobileDigitalComprehensionScorePage({super.key});

  @override
  ConsumerState<MobileDigitalComprehensionScorePage> createState() =>
      _MobileDigitalComprehensionScorePageState();
}

class _MobileDigitalComprehensionScorePageState
    extends ConsumerState<MobileDigitalComprehensionScorePage> {
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
                      const SizedBox(height: 30),

                      const PageTitle(
                        title: 'Digital Comprehension',
                        size: 18,
                        pad: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 16,
                        ),
                        child: MaterialTitleBar(
                          name:
                              'Name: ${eval.selectedStudent?.name ?? 'None selected'}',
                          gradeSection:
                              'Grade & Section: ${eval.selectedSection}',

                          nameSize: 16,
                          gradeSectionSize: 16,
                          pad: 24,
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: [
                                ComprehensionScoreBox(
                                  value: '$correct',
                                  subtitle: 'No. of Correct Answer',

                                  size: 160,
                                  valueSize: 24,
                                  subTextSize: 14,
                                ),
                                ComprehensionScoreBox(
                                  value: '$wrong',
                                  subtitle: 'No. of Wrong Answer',

                                  size: 160,
                                  valueSize: 24,
                                  subTextSize: 14,
                                ),
                                ComprehensionScoreBox(
                                  value: level,
                                  subtitle: 'Comprehension Level',

                                  size: 160,
                                  valueSize: 24,
                                  subTextSize: 14,
                                ),
                                ComprehensionScoreBox(
                                  value: '${rate.toStringAsFixed(0)}%',
                                  subtitle: 'Comprehension Rate',

                                  size: 160,
                                  valueSize: 24,
                                  subTextSize: 14,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Material(
                              elevation: 3,
                              clipBehavior: Clip.antiAlias,
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: questions.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                questions[index].questionText,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  12.0,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .tertiary;

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
                                                                    Colors.red;
                                                              }
                                                            }

                                                            return Text(
                                                              "${String.fromCharCode(65 + choiceIndex)}. $choiceValue",
                                                              style: TextStyle(
                                                                fontSize: 14,
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),

              //Proceed Button
              Positioned(
                bottom: 50,
                right: 30,
                child: CustomButton(
                  onTap: () async {
                    try {
                      final supabase = Supabase.instance.client;
                      final userId = supabase.auth.currentUser!.id;

                      final selectedStudent = eval.selectedStudent;
                      final material = ref.read(selectedMaterialProvider);

                      final readingScore = ref.watch(readingScoreProvider);
                      final assignments =
                          ref.watch(assignmentProvider).value ?? [];

                      final assignment = assignments.firstWhere(
                        (a) => a.sectionId == selectedStudent!.sectionId,
                      );

                      if (selectedStudent == null ||
                          material == null ||
                          readingScore == null) {
                        return;
                      }

                      final miscueContent = ref.watch(miscueContentProvider);

                      final readingLevel =
                          (readingScore['miscueOverallSummary'] as List?)
                              ?.firstWhere(
                                (item) => item['type'] == 'Reading Level',
                                orElse: () => {'count': 'Unknown'},
                              )['count'];

                      final answerSummary = compState.selectedAnswers.map(
                        (key, value) => MapEntry(key.toString(), value),
                      );

                      final comprehensionScore = {
                        "answerSummary": answerSummary,
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
                        assessmentType: 'Oral Reading and Comprehension',
                        readingScore: readingScore,
                        comprehensionScore: comprehensionScore,
                        totalScore: totalScore,
                        readingLevel: readingLevel,
                        miscueContent: miscueContent,
                      );

                      if (!context.mounted) return;

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return Dialog(
                            child: Container(
                              width: 300,
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
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );

                      await Future.delayed(const Duration(seconds: 3));

                      if (!context.mounted) return;

                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        PageAnimationTransition(
                          page: const MobileMainLayout(initialIndex: 2),
                          pageAnimationType: RightToLeftTransition(),
                        ),
                      );
                    } catch (e) {
                      showGlobalSnackBar('Failed to save assessment record');
                    }

                    ref.invalidate(assessmentRecordProvider);
                  },
                  title: 'Proceed',
                  size: 120,
                  vertSize: 50,
                  tSize: 16,
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

class TabletDigitalComprehensionScorePage extends ConsumerStatefulWidget {
  const TabletDigitalComprehensionScorePage({super.key});

  @override
  ConsumerState<TabletDigitalComprehensionScorePage> createState() =>
      _TabletDigitalComprehensionScorePageState();
}

class _TabletDigitalComprehensionScorePageState
    extends ConsumerState<TabletDigitalComprehensionScorePage> {
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
                      const SizedBox(height: 30),

                      const PageTitle(title: 'Digital Comprehension'),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: MaterialTitleBar(
                          name:
                              'Name: ${eval.selectedStudent?.name ?? 'None selected'}',
                          gradeSection:
                              'Grade & Section: ${eval.selectedSection}',
                        ),
                      ),
                      const SizedBox(height: 20),
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
                              borderRadius: const BorderRadius.only(
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
                                                  style: const TextStyle(
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
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .tertiary;

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
                      const SizedBox(height: 60),
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
                      final assignments =
                          ref.watch(assignmentProvider).value ?? [];

                      final assignment = assignments.firstWhere(
                        (a) => a.sectionId == selectedStudent!.sectionId,
                      );

                      if (selectedStudent == null ||
                          material == null ||
                          readingScore == null) {
                        return;
                      }

                      final miscueContent = ref.watch(miscueContentProvider);

                      final readingLevel =
                          (readingScore['miscueOverallSummary'] as List?)
                              ?.firstWhere(
                                (item) => item['type'] == 'Reading Level',
                                orElse: () => {'count': 'Unknown'},
                              )['count'];

                      final answerSummary = compState.selectedAnswers.map(
                        (key, value) => MapEntry(key.toString(), value),
                      );

                      final comprehensionScore = {
                        "answerSummary": answerSummary,
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
                        assessmentType: 'Oral Reading and Comprehension',
                        readingScore: readingScore,
                        comprehensionScore: comprehensionScore,
                        totalScore: totalScore,
                        readingLevel: readingLevel,
                        miscueContent: miscueContent,
                      );

                      if (!context.mounted) return;

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

                      await Future.delayed(const Duration(seconds: 3));
                      if (!context.mounted) return;

                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        PageAnimationTransition(
                          page: const TabletMainLayout(initialIndex: 2),
                          pageAnimationType: RightToLeftTransition(),
                        ),
                      );
                    } catch (e) {
                      showGlobalSnackBar('Failed to save assessment record');
                    }

                    ref.invalidate(assessmentRecordProvider);
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
