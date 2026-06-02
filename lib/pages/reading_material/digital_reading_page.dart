import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/components/custom_icon_button.dart';
import 'package:readbee_lite/components/page_title.dart';
import 'package:readbee_lite/components/prompt_box.dart';
import 'package:readbee_lite/pages/reading_material/digital_reading_score_page.dart';
import 'package:readbee_lite/providers/miscue_content_provider.dart';
import 'package:readbee_lite/providers/miscue_provider.dart';
import 'package:readbee_lite/providers/selected_material_provider.dart';
import 'package:readbee_lite/providers/story_provider.dart';
import 'package:readbee_lite/providers/timer_provider.dart';
import 'package:readbee_lite/providers/word_color_provider.dart';

class DigitalReadingPage extends ConsumerStatefulWidget {
  const DigitalReadingPage({super.key});

  @override
  ConsumerState<DigitalReadingPage> createState() => _DigitalReadingPageState();
}

class _DigitalReadingPageState extends ConsumerState<DigitalReadingPage> {
  @override
  Widget build(BuildContext context) {
    final selectedMaterial = ref.watch(selectedMaterialProvider);
    final storyAsync = ref.watch(storyProvider);

    if (selectedMaterial == null) {
      return const CircularProgressIndicator();
    }
    final miscues = ref.watch(miscueProvider);

    final wordState = ref.watch(wordColorMaterialProvider);

    final seconds = ref.watch(timerProvider);

    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');

    return storyAsync.when(
      data: (story) {
        if (story == null) {
          return const CircularProgressIndicator();
        }
        final titleWords = story.title.split(RegExp(r'\s+'));
        final contentWords = story.content.split(RegExp(r'\s+'));

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 30),

                  const PageTitle(title: 'Digital Reading'),

                  //Timer
                  Text(
                    '$minutes:$secs',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),

                  //Score Counter
                  Text(
                    '${miscues[7].count}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 40),

                  //Reading Material
                  Center(
                    child: Material(
                      elevation: 3,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * .45,
                        width: MediaQuery.of(context).size.width * .75,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: List.generate(titleWords.length, (
                                      index,
                                    ) {
                                      return TextSpan(
                                        text: '${titleWords[index]} ',
                                        style: TextStyle(
                                          fontSize: 34,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              wordState.wordColors[index] ??
                                              Theme.of(
                                                context,
                                              ).colorScheme.tertiary,
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: List.generate(
                                      contentWords.length,
                                      (index) {
                                        final contentIndex =
                                            titleWords.length + index;

                                        debugPrint(
                                          'ContentText: ${contentWords[index]}',
                                        );

                                        return TextSpan(
                                          text: '${contentWords[index]} ',
                                          style: TextStyle(
                                            fontSize: 30,
                                            color:
                                                wordState
                                                    .wordColors[contentIndex] ??
                                                Theme.of(
                                                  context,
                                                ).colorScheme.tertiary,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Miscue Digital Buttons
                  if (!wordState.isFinished) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 220.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 3,
                            ),
                        itemCount: miscues.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              final miscue = miscues[index];

                              final current = Map<String, List<int>>.from(
                                ref.read(miscueContentProvider),
                              );

                              current.putIfAbsent(miscue.name, () => []);

                              debugPrint('currentmismap: $current');

                              current[miscue.name]!.add(
                                ref
                                    .read(wordColorMaterialProvider)
                                    .currentIndex,
                              );

                              final started = ref.read(timerStartedProvider);

                              if (!started) {
                                ref.read(timerStartedProvider.notifier).state =
                                    true;
                                ref.read(timerProvider.notifier).start();
                              }

                              ref.read(miscueContentProvider.notifier).state =
                                  current;

                              ref
                                  .read(miscueProvider.notifier)
                                  .increment(index);

                              ref
                                  .read(wordColorMaterialProvider.notifier)
                                  .applyColor(miscue.color);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.amber,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                miscues[index].name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 30),
                ],
              ),
              //Flag & Reset Buttons
              Positioned(
                top: 150,
                right: 125,
                child: CustomIconButton(
                  icon: Icons.flag,
                  radius: 30,
                  color: Colors.grey,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => PromptBox(
                            title: 'Finish Reading?',
                            subtitle:
                                'Are you sure you want to finish the reading? This will end the session and mark the pupil as non-reader.',
                            confirmText: 'Finish',
                            cancelText: 'Cancel',
                            onCancel: () {
                              Navigator.pop(context);
                            },
                            onConfirm: () {
                              Navigator.pop(context);
                              ref.read(timerProvider.notifier).reset();
                              Navigator.push(
                                context,
                                PageAnimationTransition(
                                  page: const DigitalReadingScorePage(),
                                  pageAnimationType: RightToLeftTransition(),
                                ),
                              );
                            },
                          ),
                    );
                  },
                  iconSize: 18,
                  iconColor: Colors.white,
                ),
              ),
              Positioned(
                top: 150,
                right: 50,
                child: CustomIconButton(
                  icon: Icons.restart_alt_rounded,
                  radius: 30,
                  color: Colors.amber,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => PromptBox(
                            title: 'Reset Reading?',
                            subtitle:
                                'This will clear all your current progress and start the reading over.',
                            confirmText: 'Reset',
                            cancelText: 'Cancel',
                            onCancel: () {
                              Navigator.pop(context);
                            },
                            onConfirm: () {
                              ref
                                  .read(wordColorMaterialProvider.notifier)
                                  .reset();
                              ref.read(miscueContentProvider.notifier).state =
                                  {};
                              ref.read(miscueProvider.notifier).reset();
                              ref.read(timerProvider.notifier).reset();
                              ref.read(timerStartedProvider.notifier).state =
                                  false;
                              Navigator.pop(context);
                            },
                          ),
                    );
                  },
                  iconSize: 18,
                  iconColor: Colors.white,
                ),
              ),

              //Proceed Button
              if (wordState.isFinished)
                Positioned(
                  bottom: 50,
                  right: 50,
                  child: CustomButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageAnimationTransition(
                          page: const DigitalReadingScorePage(),
                          pageAnimationType: RightToLeftTransition(),
                        ),
                      );
                    },
                    title: 'Proceed',
                    size: 150,
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
