import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/components/page_title.dart';
import 'package:readbee_lite/components/prompt_box.dart';
import 'package:readbee_lite/pages/reading_material/digital_comprehension_score_page.dart';
import 'package:readbee_lite/providers/comprehension_provider.dart';
import 'package:readbee_lite/providers/quiz_question_provider.dart';
import 'package:readbee_lite/providers/selected_material_provider.dart';

class DigitralComprehensionPage extends ConsumerStatefulWidget {
  const DigitralComprehensionPage({super.key});

  @override
  ConsumerState<DigitralComprehensionPage> createState() =>
      _DigitralComprehensionPageState();
}

class _DigitralComprehensionPageState
    extends ConsumerState<DigitralComprehensionPage> {
  bool isDialogShowing = false;

  @override
  void initState() {
    super.initState();

    ref.listenManual(comprehensionProvider.select((s) => s.isFinished), (
      previous,
      next,
    ) {
      if (next == true && !isDialogShowing) {
        isDialogShowing = true;

        Future.microtask(() {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (_) => PromptBox(
                  title: 'Submit Assessment',
                  subtitle: 'Are you sure you want to submit?',
                  onCancel: () {
                    isDialogShowing = false;

                    Navigator.pop(context);

                    ref.read(comprehensionProvider.notifier).resetFinished();
                  },
                  onConfirm: () {
                    isDialogShowing = false;

                    Navigator.pop(context);

                    ref.read(comprehensionProvider.notifier).resetFinished();

                    Navigator.push(
                      context,
                      PageAnimationTransition(
                        page: const DigitalComprehensionScorePage(),
                        pageAnimationType: RightToLeftTransition(),
                      ),
                    );
                  },
                ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedMaterial = ref.watch(selectedMaterialProvider);
    final questionAsync = ref.watch(quizQuestionProvider);

    if (selectedMaterial == null) {
      return const CircularProgressIndicator();
    }
    final compState = ref.watch(comprehensionProvider);
    final compNotifier = ref.read(comprehensionProvider.notifier);

    final currentIndex = compState.currentQuestionIndex;

    return Stack(
      children: [
        Scaffold(
          body: Column(
            children: [
              const SizedBox(height: 30),

              const PageTitle(title: 'Digital Comprehension'),

              const SizedBox(height: 20),

              questionAsync.when(
                data: (questions) {
                  final totalQuestions = questions.length;
                  return Column(
                    children: [
                      //Progress Indicator
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SizedBox(
                          height: 30,
                          width: MediaQuery.of(context).size.width * .7,
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(12),
                            value: (currentIndex + 1) / totalQuestions,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      //Questions
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .8,
                          height: MediaQuery.of(context).size.height * .3,
                          child: Card(
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Center(
                                child: Text(
                                  questions[currentIndex].questionText,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 42),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),

                      //Choices
                      SizedBox(
                        height: 220,
                        child: Center(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: questions[currentIndex].choices.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 220,
                                  child: Card(
                                    elevation: 3,
                                    child: InkWell(
                                      onTap: () {
                                        compNotifier.selectAnswer(
                                          totalQuestions: questions.length,
                                          answer:
                                              questions[currentIndex]
                                                  .choices[index]
                                                  .letter,
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Center(
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            questions[currentIndex]
                                                .choices[index]
                                                .choice,
                                            style: const TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text(e.toString()),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
        Positioned(
          bottom: 50,
          right: 50,
          child: CustomButton(
            onTap: () {
              ref.read(comprehensionProvider.notifier).undoAnswer();
            },
            title: 'Back',
            size: 150,
          ),
        ),
      ],
    );
  }
}
