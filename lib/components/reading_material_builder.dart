import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/models/reading_material.dart';
import 'package:readbee_lite/pages/reading_material/reading_material_details_page.dart';
import 'package:readbee_lite/providers/selected_material_provider.dart';

class ReadingMaterialBuilder extends ConsumerWidget {
  final List<ReadingMaterial> material;
  const ReadingMaterialBuilder({super.key, required this.material});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
        child: GridView.builder(
          itemCount: material.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          padding: const EdgeInsets.only(bottom: 150),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ref.read(selectedMaterialProvider.notifier).state =
                          material[index];
                      debugPrint('Book: ${material[index].title}');
                      debugPrint('WordLength: ${material[index].wordCount}');
                      // debugPrint(
                      //   'questionLength: ${material[index].question.length}',
                      // );
                      // Navigator.push(
                      //   context,
                      //   PageAnimationTransition(
                      //     page: ReadingMaterialDetailsPage(),
                      //     pageAnimationType: RightToLeftTransition(),
                      //   ),
                      // );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Text(
                  material[index].title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22),
                  maxLines: 1,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
