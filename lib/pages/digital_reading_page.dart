import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/components/custom_icon_button.dart';
import 'package:readbee_lite/pages/digital_reading_score_page.dart';
import 'package:readbee_lite/providers/miscue_provider.dart';
import 'package:readbee_lite/providers/reading_material_provider.dart';
import 'package:readbee_lite/providers/word_color_provider.dart';

class DigitalReadingPage extends ConsumerStatefulWidget {
  const DigitalReadingPage({super.key});

  @override
  ConsumerState<DigitalReadingPage> createState() => _DigitalReadingPageState();
}

class _DigitalReadingPageState extends ConsumerState<DigitalReadingPage> {
  @override
  Widget build(BuildContext context) {
    final material = ref.watch(readingMaterialProvider);
    final miscues = ref.watch(miscueProvider);

    final wordState = ref.watch(wordColorMaterialProvider);

    final titleWords = material[0].title.split(' ');
    final contentWords = material[0].content.split(' ');
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 40),

              //Timer
              Text(
                '00:00',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20),

              //Score Counter
              Text(
                '${miscues[7].count}',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 40),

              //Reading Material
              Center(
                child: Material(
                  elevation: 3,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .5,
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
                                          Colors.black,
                                    ),
                                  );
                                }),
                              ),
                            ),
                            SizedBox(height: 20),
                            // Text(
                            //   material[0].content,
                            //   textAlign: TextAlign.center,
                            //   style: TextStyle(fontSize: 30),
                            // ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: List.generate(contentWords.length, (
                                  index,
                                ) {
                                  final contentIndex =
                                      titleWords.length + index;

                                  return TextSpan(
                                    text: '${contentWords[index]} ',
                                    style: TextStyle(
                                      fontSize: 30,
                                      color:
                                          wordState.wordColors[contentIndex] ??
                                          Colors.black,
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

              Spacer(),

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

                          ref.read(miscueProvider.notifier).increment(index);

                          ref
                              .read(wordColorMaterialProvider.notifier)
                              .applyColor(miscue.color);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.blue,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            miscues[index].name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
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

              SizedBox(height: 30),
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
              onTap: () {},
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
                ref.read(miscueProvider.notifier).reset();
                ref.read(wordColorMaterialProvider.notifier).reset();
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
                      page: DigitalReadingScorePage(),
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
  }
}
