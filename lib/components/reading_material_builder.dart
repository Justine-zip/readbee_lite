import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:readbee_lite/models/reading_material.dart';
import 'package:readbee_lite/viewmodels/providers/selected_material_provider.dart';
import 'package:readbee_lite/views/reading_material/reading_material_details_page.dart';

class ReadingMaterialBuilder extends ConsumerWidget {
  final List<ReadingMaterial> material;
  final bool? isMobile;
  final int? axisCount;
  final double? titleSize;
  const ReadingMaterialBuilder({
    super.key,
    required this.material,
    this.isMobile,
    this.axisCount,
    this.titleSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
      child: GridView.builder(
        itemCount: material.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: axisCount ?? 5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        padding: const EdgeInsets.only(bottom: 150),
        itemBuilder: (context, index) {
          final item = material[index];

          return Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.read(selectedMaterialProvider.notifier).state = item;

                    debugPrint('MaterialId: ${item.materialId}');
                    debugPrint('Book: ${item.title}');
                    debugPrint('Description: ${item.description}');
                    debugPrint('Language: ${item.language}');
                    debugPrint('WordLength: ${item.wordCount}');
                    debugPrint('StoryId: ${item.storyId}');

                    Navigator.push(
                      context,
                      PageAnimationTransition(
                        page:
                            isMobile != null
                                ? const MobileReadingMaterialDetailsPage()
                                : const TabletReadingMaterialDetailsPage(),
                        pageAnimationType: RightToLeftTransition(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image:
                            (item.coverImage?.isNotEmpty ?? false)
                                ? MemoryImage(
                                  base64Decode(
                                    item.coverImage!.split(',').last,
                                  ),
                                )
                                : const AssetImage('assets/img/storybook.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                item.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: titleSize ?? 22),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
      ),
    );
  }
}
