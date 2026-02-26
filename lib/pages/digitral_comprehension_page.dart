import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/components/prompt_box.dart';
import 'package:readbee_lite/pages/digital_comprehension_score_page.dart';
import 'package:readbee_lite/providers/comprehension_provider.dart';
import 'package:readbee_lite/providers/reading_material_provider.dart';

class DigitralComprehensionPage extends ConsumerStatefulWidget {
  const DigitralComprehensionPage({super.key});

  @override
  ConsumerState<DigitralComprehensionPage> createState() =>
      _DigitralComprehensionPageState();
}

class _DigitralComprehensionPageState
    extends ConsumerState<DigitralComprehensionPage> {
  @override
  Widget build(BuildContext context) {
    final question = ref.watch(readingMaterialProvider);
    final material = ref.watch(readingMaterialProvider);
    final compState = ref.watch(comprehensionProvider);
    final compNotifier = ref.read(comprehensionProvider.notifier);

    final currentIndex = compState.currentQuestionIndex;
    final totalQuestions = material[0].question.length;

    if (compState.isFinished) {
      Future.microtask(() {
        debugPrint('Answer: ${compState.selectedAnswers}');
        if (mounted) {
          showDialog(
            context: context,
            builder: (_) {
              return PromptBox(
                title: 'Submit Assessment',
                subtitle: 'Are you sure you want to submit?',
                onConfirm: () {
                  Navigator.pop(context);
                  ref.read(comprehensionProvider.notifier).resetFinished();
                  Navigator.push(
                    context,
                    PageAnimationTransition(
                      page: DigitalComprehensionScorePage(),
                      pageAnimationType: RightToLeftTransition(),
                    ),
                  );
                },
              );
            },
          );
        }
      });
    }
    return Stack(
      children: [
        Scaffold(
          body: Column(
            children: [
              SizedBox(height: 30),

              //Progress Indicator
              SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width * .7,
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(12),
                  value: (currentIndex + 1) / totalQuestions,
                ),
              ),

              SizedBox(height: 30),

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
                          question[0].question[currentIndex],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 42),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),

              //Choices
              SizedBox(
                height: 220,
                child: Center(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: question[0].choice[currentIndex].length,
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
                                  totalQuestions: totalQuestions,
                                  answer:
                                      material[0].choice[currentIndex][index],
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Center(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    question[0].choice[currentIndex][index],
                                    style: TextStyle(fontSize: 24),
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

              SizedBox(height: 50),
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
