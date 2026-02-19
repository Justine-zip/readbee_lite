import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/pages/reading_material_details_page.dart';

class ReadingMaterialBuilder extends StatelessWidget {
  ReadingMaterialBuilder({super.key});

  final List<String> title = [
    'Maharlika',
    'Ang Aso sa Lungga',
    'Nawawalang libro',
    'Ang tao sa ilalim ng tulay',
    'Apoy sa Gubat',
    'Kisame ng mga Bituin',
    'Alamat ng Duwende',
    'Sintunadong Oso',
    'Mga mata sa lupa',
    'Apat na paa ng Engkanto',
    'Bahay na kahoy sa dilim',
    'Mga sigaw ng ibon',
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
        child: GridView.builder(
          itemCount: title.length,
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
                      debugPrint('Book: ${title[index]}');
                      debugPrint('WordLength: ${title[index].length}');
                      Navigator.push(
                        context,
                        PageAnimationTransition(
                          page: ReadingMaterialDetailsPage(
                            title: title[index],
                            language: 'Tagalog',
                            wordLength: title[index].length,
                          ),
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
                  title[index],
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
