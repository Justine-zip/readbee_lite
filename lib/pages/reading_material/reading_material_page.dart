import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/components/custom_textfield.dart';
import 'package:readbee_lite/components/filter_sheet.dart';
import 'package:readbee_lite/components/reading_material_builder.dart';
import 'package:readbee_lite/components/title_bar.dart';
import 'package:readbee_lite/providers/comprehension_provider.dart';
import 'package:readbee_lite/providers/evaluation_list_provider.dart';
import 'package:readbee_lite/providers/material_filter_provider.dart';
import 'package:readbee_lite/providers/miscue_content_provider.dart';
import 'package:readbee_lite/providers/miscue_provider.dart';
import 'package:readbee_lite/providers/timer_provider.dart';
import 'package:readbee_lite/providers/word_color_provider.dart';

class MobileReadingMaterialPage extends ConsumerStatefulWidget {
  const MobileReadingMaterialPage({super.key});

  @override
  ConsumerState<MobileReadingMaterialPage> createState() =>
      _MobileReadingMaterialPageState();
}

class _MobileReadingMaterialPageState
    extends ConsumerState<MobileReadingMaterialPage> {
  DraggableScrollableController controller = DraggableScrollableController();
  @override
  void initState() {
    super.initState();
    ref.read(evaluationProvider.notifier).reset();
    ref.read(wordColorMaterialProvider.notifier).reset();
    ref.read(miscueProvider.notifier).reset();
    ref.read(comprehensionProvider.notifier).reset();
    ref.read(timerProvider.notifier).reset();
    ref.read(timerStartedProvider.notifier).state = false;
  }

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
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.invalidate(evaluationProvider);
      ref.invalidate(wordColorMaterialProvider);
      ref.invalidate(miscueProvider);
      ref.invalidate(comprehensionProvider);
      ref.read(timerProvider.notifier).reset();
      ref.read(timerStartedProvider.notifier).state = false;
      ref.read(miscueContentProvider.notifier).state = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    final material = ref.watch(filteredReadingMaterialProvider);
    return Stack(
      children: [
        Scaffold(
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
                              return FilterSheet(
                                textSize: 1.25,
                                sheetSize: .30,
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.filter_alt_rounded),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                material.when(
                  loading: () => Center(child: CircularProgressIndicator()),
                  data: (data) {
                    return ReadingMaterialBuilder(material: data);
                  },
                  error:
                      (error, stackTrace) =>
                          Center(child: Text(error.toString())),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 130,
          right: 50,
          child: SizedBox(
            width: 70,
            height: 70,
            child: FloatingActionButton(
              onPressed: () {
                debugPrint('add Material');
              },
              child: const Icon(Icons.add, size: 36),
            ),
          ),
        ),
        Positioned(
          bottom: 130,
          right: 50,
          child: SizedBox(
            width: 70,
            height: 70,
            child: FloatingActionButton(
              backgroundColor: Colors.amber,
              onPressed: () {
                debugPrint('add Material');
                showDialog(
                  context: context,
                  builder: (_) => const StoryDialog(),
                );
              },
              child: const Icon(Icons.add, size: 36, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class StoryDialog extends ConsumerWidget {
  const StoryDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Add Story'),
      backgroundColor: Colors.white,
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 550),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .7,
          width: MediaQuery.of(context).size.width * .3,
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 200,
                child: TextField(
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    hintText: 'Story Content',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              SizedBox(height: 15),
              CustomButton(
                onTap: () {
                  debugPrint('Scan');
                },
                title: 'Scan from Img',
              ),
              SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Grade Level',
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
              SizedBox(height: 15),
              Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Words',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Language',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: CustomButton(
                  onTap: () {
                    debugPrint('Next');
                    Navigator.pop(context);
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (_) => const QuizlDialog(),
                    );
                  },
                  title: 'Next',
                  size: 100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizlDialog extends ConsumerWidget {
  const QuizlDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Add Quiz Question'),
      backgroundColor: Colors.white,
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 550),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .7,
          width: MediaQuery.of(context).size.width * .3,
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: TextField(
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    hintText: 'Story Content',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  hintText: 'A',
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  hintText: 'B',
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  hintText: 'C',
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  hintText: 'D',
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Correct Answer (A/B/C/D)',
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: CustomButton(
                  onTap: () {
                    debugPrint('Submit');
                  },
                  title: 'Submit',
                  size: 100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
