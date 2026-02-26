import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/components/comprehension_score_box.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/components/title_bar.dart';
import 'package:readbee_lite/pages/digitral_comprehension_page.dart';
import 'package:readbee_lite/providers/reading_material_provider.dart';

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
    final material = ref.watch(readingMaterialProvider);
    return Stack(
      children: [
        Scaffold(
          body: Column(
            children: [
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: TitleBar(
                  title: 'Student Name Sample',
                  description: 'description',
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ComprehensionScoreBox(
                                value: '3',
                                subtitle: 'No. of Correct Answer',
                              ),
                              ComprehensionScoreBox(
                                value: '2',
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
                                value: '60%',
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
                                  itemCount: material[0].question.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          material[0].question[index],
                                          style: TextStyle(fontSize: 22),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              for (var key
                                                  in material[0].key[index]
                                                      .asMap()
                                                      .entries)
                                                Text(
                                                  "${String.fromCharCode(65 + key.key)}. ${key.value}",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                  ),
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
            ],
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
            size: 200,
          ),
        ),
      ],
    );
  }
}
