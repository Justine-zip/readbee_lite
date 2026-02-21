import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/components/custom_textfield.dart';
import 'package:readbee_lite/components/filter_sheet.dart';
import 'package:readbee_lite/components/reading_material_builder.dart';
import 'package:readbee_lite/components/title_bar.dart';
import 'package:readbee_lite/providers/reading_material_provider.dart';

class MobileReadingMaterialPage extends StatefulWidget {
  const MobileReadingMaterialPage({super.key});

  @override
  State<MobileReadingMaterialPage> createState() =>
      _MobileReadingMaterialPageState();
}

class _MobileReadingMaterialPageState extends State<MobileReadingMaterialPage> {
  DraggableScrollableController controller = DraggableScrollableController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            const Text(
              'Reading Materials',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomTextfield(hint: 'Search...'),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return FilterSheet(textSize: 1, sheetSize: .4);
                      },
                    );
                  },
                  icon: const Icon(Icons.filter_alt_rounded),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                itemCount: 12,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            debugPrint('Book $index');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      Text('Book $index', textAlign: TextAlign.center),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabletReadingMaterialPage extends ConsumerStatefulWidget {
  const TabletReadingMaterialPage({super.key});

  @override
  ConsumerState<TabletReadingMaterialPage> createState() =>
      _TabletReadingMaterialPageState();
}

class _TabletReadingMaterialPageState
    extends ConsumerState<TabletReadingMaterialPage> {
  DraggableScrollableController controller = DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    final material = ref.watch(readingMaterialProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            TitleBar(
              title: 'Reading Materials',
              description:
                  'Select reading materials to assess students, ensuring accurate and organized evaluation of tjeir reading skills',
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CustomTextfield(hint: 'Search...'),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return FilterSheet(textSize: 1.25, sheetSize: .45);
                        },
                      );
                    },
                    icon: const Icon(Icons.filter_alt_rounded),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ReadingMaterialBuilder(material: material),
          ],
        ),
      ),
    );
  }
}
