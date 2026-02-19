import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/models/reading_material.dart';
import 'package:readbee_lite/pages/reading_material_details_page.dart';

class ReadingMaterialBuilder extends StatelessWidget {
  final List<ReadingMaterial> material;
  const ReadingMaterialBuilder({super.key, required this.material});

  @override
  Widget build(BuildContext context) {
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
                      debugPrint('Book: ${material[0].title}');
                      debugPrint('WordLength: ${material[0].wordLength}');
                      debugPrint(
                        'questionLength: ${material[0].question.length}',
                      );
                      Navigator.push(
                        context,
                        PageAnimationTransition(
                          page: ReadingMaterialDetailsPage(material: material),
                          pageAnimationType: RightToLeftTransition(),
                        ),
                      );
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
                  material[0].title,
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
