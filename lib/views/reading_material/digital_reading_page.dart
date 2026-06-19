import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/components/custom_icon_button.dart';
import 'package:readbee_lite/components/page_title.dart';
import 'package:readbee_lite/components/prompt_box.dart';
import 'package:readbee_lite/viewmodels/providers/miscue_content_provider.dart';
import 'package:readbee_lite/viewmodels/providers/miscue_provider.dart';
import 'package:readbee_lite/viewmodels/providers/selected_material_provider.dart';
import 'package:readbee_lite/viewmodels/providers/story_provider.dart';
import 'package:readbee_lite/viewmodels/providers/timer_provider.dart';
import 'package:readbee_lite/viewmodels/providers/word_color_provider.dart';
import 'package:readbee_lite/views/reading_material/digital_reading_score_page.dart';

class MobileDigitalReadingPage extends ConsumerStatefulWidget {
  const MobileDigitalReadingPage({super.key});

  @override
  ConsumerState<MobileDigitalReadingPage> createState() =>
      _MobileDigitalReadingPageState();
}

class _MobileDigitalReadingPageState
    extends ConsumerState<MobileDigitalReadingPage> {
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

                  const PageTitle(title: 'Digital Reading', size: 18, pad: 30),

                  const SizedBox(height: 30),

                  //Timer
                  Text(
                    '$minutes:$secs',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),

                  //Score Counter
                  Text(
                    '${miscues[7].count}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 40),

                  //Reading Material
                  Center(
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(12),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * .35,
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
                                      children: List.generate(
                                        titleWords.length,
                                        (index) {
                                          return TextSpan(
                                            text: '${titleWords[index]} ',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  wordState.wordColors[index] ??
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.tertiary,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: List.generate(contentWords.length, (
                                        index,
                                      ) {
                                        final contentIndex =
                                            titleWords.length + index;

                                        debugPrint(
                                          'ContentText: ${contentWords[index]}',
                                        );

                                        return TextSpan(
                                          text: '${contentWords[index]} ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                wordState
                                                    .wordColors[contentIndex] ??
                                                Theme.of(
                                                  context,
                                                ).colorScheme.tertiary,
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                              childAspectRatio: 1,
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
                                color:
                                    index % 2 != 0
                                        ? Colors.amber[100]
                                        : Colors.amber[200],
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  miscues[index].name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
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
                right: 75,
                child: CustomIconButton(
                  icon: Icons.flag,
                  iconSize: 14,
                  iconColor: Colors.white,
                  radius: 20,
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

                            contPad: 60,

                            titleSize: 16,
                            subtitleSize: 14,
                            buttonStyle: const [14, 14, 12, 80],

                            onCancel: () {
                              Navigator.pop(context);
                            },
                            onConfirm: () {
                              Navigator.pop(context);
                              ref.read(timerProvider.notifier).reset();
                              Navigator.push(
                                context,
                                PageAnimationTransition(
                                  page: const MobileDigitalReadingScorePage(),
                                  pageAnimationType: RightToLeftTransition(),
                                ),
                              );
                            },
                          ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 150,
                right: 30,
                child: CustomIconButton(
                  icon: Icons.restart_alt_rounded,
                  iconSize: 14,
                  iconColor: Colors.white,
                  radius: 20,
                  color: Colors.amber,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => PromptBox(
                            title: 'Reset Reading?',
                            subtitle:
                                'This will clear all your current progress and start the reading over.',

                            contPad: 60,

                            titleSize: 16,
                            subtitleSize: 14,
                            buttonStyle: const [14, 14, 12, 80],

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
                ),
              ),

              //Proceed Button
              if (wordState.isFinished)
                Positioned(
                  bottom: 50,
                  right: 30,
                  child: CustomButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageAnimationTransition(
                          page: const MobileDigitalReadingScorePage(),
                          pageAnimationType: RightToLeftTransition(),
                        ),
                      );
                    },
                    title: 'Proceed',
                    tSize: 14,
                    pad: 12,
                    size: 100,
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

class TabletDigitalReadingPage extends ConsumerStatefulWidget {
  const TabletDigitalReadingPage({super.key});

  @override
  ConsumerState<TabletDigitalReadingPage> createState() =>
      _TabletDigitalReadingPageState();
}

class _TabletDigitalReadingPageState
    extends ConsumerState<TabletDigitalReadingPage> {
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
                                  page: const TabletDigitalReadingScorePage(),
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
                          page: const TabletDigitalReadingScorePage(),
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
