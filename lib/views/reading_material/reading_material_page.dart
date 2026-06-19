import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/components/custom_textfield.dart';
import 'package:readbee_lite/components/filter_sheet.dart';
import 'package:readbee_lite/components/reading_material_builder.dart';
import 'package:readbee_lite/components/title_bar.dart';
import 'package:readbee_lite/models/grade_level.dart';
import 'package:readbee_lite/models/material_draft.dart';
import 'package:readbee_lite/models/user_role.dart';
import 'package:readbee_lite/viewmodels/providers/comprehension_provider.dart';
import 'package:readbee_lite/viewmodels/providers/evaluation_list_provider.dart';
import 'package:readbee_lite/viewmodels/providers/grade_level_provider.dart';
import 'package:readbee_lite/viewmodels/providers/material_draft_provider.dart';
import 'package:readbee_lite/viewmodels/providers/material_filter_provider.dart';
import 'package:readbee_lite/viewmodels/providers/miscue_content_provider.dart';
import 'package:readbee_lite/viewmodels/providers/miscue_provider.dart';
import 'package:readbee_lite/viewmodels/providers/timer_provider.dart';
import 'package:readbee_lite/viewmodels/providers/user_role_provider.dart';
import 'package:readbee_lite/viewmodels/providers/word_color_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MobileReadingMaterialPage extends ConsumerStatefulWidget {
  const MobileReadingMaterialPage({super.key});

  @override
  ConsumerState<MobileReadingMaterialPage> createState() =>
      _MobileReadingMaterialPageState();
}

class _MobileReadingMaterialPageState
    extends ConsumerState<MobileReadingMaterialPage> {
  DraggableScrollableController controller = DraggableScrollableController();

  final GlobalKey materialKey = GlobalKey();
  final GlobalKey filterKey = GlobalKey();
  final GlobalKey searchKey = GlobalKey();
  final GlobalKey addKey = GlobalKey();

  Future<void> showShowcase(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    final hasShown = prefs.getBool('hasShownMaterialShowcase') ?? false;

    if (!hasShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(
          context,
        ).startShowCase([materialKey, searchKey, filterKey, addKey]);
      });

      await prefs.setBool('hasShownMaterialShowcase', true);
    }
  }

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showShowcase(context);
    });
  }

  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final material = ref.watch(filteredReadingMaterialProvider);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const TitleBar(
                  title: 'Reading Materials',
                  description:
                      'Select reading materials to assess students, ensuring accurate and organized evaluation of tjeir reading skills',
                  titleSize: 16,
                  descriptionSize: 12,
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Showcase(
                        key: searchKey,
                        title: 'Search Materials',
                        description:
                            'Search for reading materials by title, grade level, or language.',
                        titleTextStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        descTextStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        child: CustomTextfield(
                          controller: searchController,
                          hint: 'Search...',
                          hintSize: 14,
                          onChanged: (value) {
                            ref.read(materialSearchProvider.notifier).state =
                                value;
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return const FilterSheet(
                                textSize: .9,
                                sheetSize: .3,
                              );
                            },
                          );
                        },
                        icon: Showcase(
                          key: filterKey,
                          title: 'Filter Materials',
                          description:
                              'Filter reading materials by grade level or language.',
                          titleTextStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          descTextStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          child: const Icon(Icons.filter_alt_rounded, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: material.when(
                    loading:
                        () => Center(
                          child: Container(
                            color: Colors.transparent,
                            child: const Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/splashscreen/LoadingBee.gif',
                                ),
                                width: 150,
                                height: 150,
                                gaplessPlayback: true,
                              ),
                            ),
                          ),
                        ),
                    data: (data) {
                      return Showcase(
                        key: materialKey,
                        title: 'Explore Reading Materials',
                        description:
                            'Tap a material to view details, assessments, and student performance.',
                        titleTextStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        descTextStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        child: ReadingMaterialBuilder(
                          material: data,
                          isMobile: true,
                          axisCount: 2,
                          titleSize: 12,
                        ),
                      );
                    },
                    error:
                        (error, stackTrace) =>
                            Center(child: Text(error.toString())),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          right: 30,
          child: SizedBox(
            width: 50,
            height: 50,
            child: Showcase(
              key: addKey,
              title: 'Add Reading Material',
              description: 'Add a new reading material.',
              titleTextStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              descTextStyle: const TextStyle(fontSize: 14, color: Colors.black),
              child: FloatingActionButton(
                backgroundColor: Colors.amber,
                onPressed: () {
                  debugPrint('add Material');
                  showDialog(
                    context: context,
                    builder:
                        (_) => const StoryDialog(
                          contSize: .65,
                          titleSize: 18,
                          hintSize: 12,
                          errorSize: 10,
                          iconSize: 14,
                          buttonStyle: [8, 14, 6],

                          quizOptionTitle: 16,
                          quizOptionIcon: 24,
                          quizOptionSubtitle: 14,

                          quizTitleSize: 16,
                          quizHintSize: 12,
                          quizLabelSize: 12,
                          quizButtonStyle: [8, 14, 6],
                        ),
                  );
                },
                child: const Icon(Icons.add, size: 32, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
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

  final GlobalKey materialKey = GlobalKey();
  final GlobalKey filterKey = GlobalKey();
  final GlobalKey searchKey = GlobalKey();
  final GlobalKey addKey = GlobalKey();

  Future<void> showShowcase(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    final hasShown = prefs.getBool('hasShownMaterialShowcase') ?? false;

    if (!hasShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(
          context,
        ).startShowCase([materialKey, searchKey, filterKey, addKey]);
      });

      await prefs.setBool('hasShownMaterialShowcase', true);
    }
  }

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showShowcase(context);
    });
  }

  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
                const SizedBox(height: 25),
                const TitleBar(
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
                      Showcase(
                        key: searchKey,
                        title: 'Search Materials',
                        description:
                            'Search for reading materials by title, grade level, or language.',
                        child: CustomTextfield(
                          controller: searchController,
                          hint: 'Search...',
                          onChanged: (value) {
                            ref.read(materialSearchProvider.notifier).state =
                                value;
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return const FilterSheet(
                                textSize: 1.25,
                                sheetSize: .30,
                              );
                            },
                          );
                        },
                        icon: Showcase(
                          key: filterKey,
                          title: 'Filter Materials',
                          description:
                              'Filter reading materials by grade level or language.',
                          child: const Icon(Icons.filter_alt_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: material.when(
                    loading:
                        () => Center(
                          child: Container(
                            color: Colors.transparent,
                            child: const Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/splashscreen/LoadingBee.gif',
                                ),
                                width: 200,
                                height: 200,
                                gaplessPlayback: true,
                              ),
                            ),
                          ),
                        ),
                    data: (data) {
                      return Showcase(
                        key: materialKey,
                        title: 'Explore Reading Materials',
                        description:
                            'Tap a material to view details, assessments, and student performance.',
                        child: ReadingMaterialBuilder(material: data),
                      );
                    },
                    error:
                        (error, stackTrace) =>
                            Center(child: Text(error.toString())),
                  ),
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
            child: Showcase(
              key: addKey,
              title: 'Add Reading Material',
              description: 'Add a new reading material.',
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
        ),
      ],
    );
  }
}

class StoryDialog extends ConsumerStatefulWidget {
  final double? contSize;
  final double? titleSize;
  final double? hintSize;
  final double? errorSize;
  final double? iconSize;
  final List<double>? buttonStyle;

  final double? quizOptionTitle;
  final double? quizOptionIcon;
  final double? quizOptionSubtitle;

  final double? quizTitleSize;
  final double? quizHintSize;
  final double? quizLabelSize;
  final List<double>? quizButtonStyle;

  const StoryDialog({
    super.key,
    this.contSize,
    this.titleSize,
    this.hintSize,
    this.errorSize,
    this.iconSize,
    this.buttonStyle,

    this.quizOptionTitle,
    this.quizOptionIcon,
    this.quizOptionSubtitle,

    this.quizTitleSize,
    this.quizHintSize,
    this.quizLabelSize,
    this.quizButtonStyle,
  });

  @override
  ConsumerState<StoryDialog> createState() => _StoryDialogState();
}

class _StoryDialogState extends ConsumerState<StoryDialog> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final gradeController = TextEditingController();
  final wordController = TextEditingController();
  final languageController = TextEditingController();

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    titleController.addListener(_updateWordCount);
    contentController.addListener(_updateWordCount);
  }

  void _updateWordCount() {
    final text = '${titleController.text} ${contentController.text}'.trim();

    final count = text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;

    wordController.text = count.toString();
  }

  @override
  void dispose() {
    titleController.removeListener(_updateWordCount);
    contentController.removeListener(_updateWordCount);

    titleController.dispose();
    contentController.dispose();
    gradeController.dispose();
    wordController.dispose();
    languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(materialDraftProvider.notifier);
    final draft = ref.watch(materialDraftProvider);

    final ImagePicker picker = ImagePicker();

    Future<String> extractTextFromImage(File imageFile) async {
      final inputImage = InputImage.fromFile(imageFile);

      final textRecognizer = TextRecognizer(
        script: TextRecognitionScript.latin,
      );

      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      for (final block in recognizedText.blocks) {
        debugPrint('Blockx: ${block.text}');
      }

      await textRecognizer.close();

      return recognizedText.text;
    }

    Future<void> pickImage() async {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final file = File(image.path);

      final extractedText = await extractTextFromImage(file);

      debugPrint(extractedText);

      final lines =
          extractedText
              .split('\n')
              .where((line) => line.trim().isNotEmpty)
              .toList();

      if (lines.isNotEmpty) {
        titleController.text = lines.first;
        contentController.text = lines.skip(1).join('\n');
      } else {
        titleController.clear();
        contentController.clear();
      }
    }

    return AlertDialog(
      title: Text('Add Story', style: TextStyle(fontSize: widget.titleSize)),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: widget.contSize != null ? 430 : 450,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * (widget.contSize ?? .7),
          width: MediaQuery.of(context).size.width * .3,
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(fontSize: widget.hintSize),
                  border: const OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                height: 150,
                child: TextField(
                  controller: contentController,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: 'Story Content',
                    hintStyle: TextStyle(fontSize: widget.hintSize),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: const SizedBox(),
                  value:
                      (draft.gradeLevelId == null ||
                              draft.gradeLevelId!.isEmpty)
                          ? null
                          : draft.gradeLevelId,
                  hint: Text(
                    'Select Grade Level',
                    style: TextStyle(fontSize: widget.hintSize),
                  ),
                  style: TextStyle(
                    fontSize: widget.hintSize,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  items: const [
                    DropdownMenuItem(value: '3', child: Text('Grade 3')),
                    DropdownMenuItem(value: '4', child: Text('Grade 4')),
                    DropdownMenuItem(value: '5', child: Text('Grade 5')),
                    DropdownMenuItem(value: '6', child: Text('Grade 6')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _errorMessage = null;
                    });
                    ref
                        .read(materialDraftProvider.notifier)
                        .setGradeLevel(value);
                  },
                ),
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: wordController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Words',
                        hintStyle: TextStyle(fontSize: widget.hintSize),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue:
                          languageController.text.isEmpty
                              ? null
                              : languageController.text,
                      style: TextStyle(
                        fontSize: widget.hintSize,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),

                      decoration: InputDecoration(
                        hintText: 'Language',
                        hintStyle: TextStyle(fontSize: widget.hintSize),

                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'English',
                          child: Text(
                            'English',
                            style: TextStyle(fontSize: widget.hintSize),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Filipino',
                          child: Text(
                            'Filipino',
                            style: TextStyle(fontSize: widget.hintSize),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _errorMessage = null;
                        });
                        languageController.text = value ?? '';
                        debugPrint(
                          'LanguageController: ${languageController.text}',
                        );
                      },
                    ),
                  ),
                ],
              ),
              const Spacer(),

              if (_errorMessage != null) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.redAccent,
                        size: widget.iconSize ?? 20,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: widget.errorSize ?? 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    title: 'Scan Img',
                    size: 100,
                    pad: widget.buttonStyle?[0],
                    tSize: widget.buttonStyle?[1],
                    radius: widget.buttonStyle?[2],
                    onTap: () async {
                      debugPrint('Scan Image');
                      await pickImage();
                    },
                  ),
                  CustomButton(
                    title: 'Next',
                    size: 80,
                    pad: widget.buttonStyle?[0],
                    tSize: widget.buttonStyle?[1],
                    radius: widget.buttonStyle?[2],
                    onTap: () {
                      final title = titleController.text.trim();
                      final content = contentController.text.trim();
                      final gradeLevel = draft.gradeLevelId;
                      final language = languageController.text.trim();

                      if (title.isEmpty ||
                          content.isEmpty ||
                          gradeLevel == null ||
                          gradeLevel.isEmpty ||
                          language.isEmpty) {
                        setState(() {
                          _errorMessage =
                              'All fields are required before proceeding.';
                        });
                        return;
                      }

                      setState(() {
                        _errorMessage = null;
                      });

                      notifier.setTitle(title);
                      notifier.setContent(content);
                      notifier.setWordCount(
                        int.tryParse(wordController.text) ?? 0,
                      );
                      notifier.setLanguage(language);

                      debugPrint('draft.gradeLevelId =: ${draft.gradeLevelId}');

                      Navigator.pop(context);

                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder:
                            (_) => QuizDialogOption(
                              titleSize: widget.quizOptionTitle,
                              iconSize: widget.quizOptionIcon,
                              subtitleSize: widget.quizOptionSubtitle,

                              quizTitleSize: widget.quizTitleSize,
                              quizHintSize: widget.quizHintSize,
                              quizLabelSize: widget.quizLabelSize,
                              quizButtonStyle: widget.quizButtonStyle,
                            ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizDialogOption extends StatelessWidget {
  final double? titleSize;
  final double? iconSize;
  final double? subtitleSize;

  final double? quizTitleSize;
  final double? quizHintSize;
  final double? quizLabelSize;
  final List<double>? quizButtonStyle;
  const QuizDialogOption({
    super.key,
    this.titleSize,
    this.iconSize,
    this.subtitleSize,

    this.quizTitleSize,
    this.quizHintSize,
    this.quizLabelSize,
    this.quizButtonStyle,
  });

  @override
  Widget build(BuildContext context) {
    final ImagePicker picker = ImagePicker();

    Future<String> extractTextFromImage(File imageFile) async {
      final inputImage = InputImage.fromFile(imageFile);

      final textRecognizer = TextRecognizer(
        script: TextRecognitionScript.latin,
      );

      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      for (final block in recognizedText.blocks) {
        debugPrint('QuizBlockx: ${block.text}');
      }

      await textRecognizer.close();

      return recognizedText.text;
    }

    Future<List<Map<String, dynamic>>> pickImage() async {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return [];

      final file = File(image.path);
      final extractedText = await extractTextFromImage(file);

      final lines =
          extractedText
              .split('\n')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();

      final questionRegExp = RegExp(r'^(?![a-zA-Z]\.)(?!\d+$).+$');
      final choicesRegExp = RegExp(r'^[a-zA-Z]\..*');

      final List<Map<String, dynamic>> quizItems = [];

      String currentQuestionBlock = "";
      List<String> currentChoicesBlock = [];

      for (final line in lines) {
        final trimmedLine = line.trim();
        if (trimmedLine.isEmpty) continue;

        final questionMatch = questionRegExp.firstMatch(trimmedLine);
        final choiceMatch = choicesRegExp.firstMatch(trimmedLine);

        if (questionMatch != null) {
          if (currentChoicesBlock.isNotEmpty) {
            quizItems.add({
              'question': currentQuestionBlock,
              'choices': List<String>.from(currentChoicesBlock),
            });
            currentQuestionBlock = "";
            currentChoicesBlock.clear();
          }

          final text = questionMatch.group(0)!;
          if (currentQuestionBlock.isEmpty) {
            currentQuestionBlock = text;
          } else {
            currentQuestionBlock += " $text";
          }
        } else if (choiceMatch != null) {
          currentChoicesBlock.add(choiceMatch.group(0)!);
        }
      }

      if (currentQuestionBlock.isNotEmpty) {
        quizItems.add({
          'question': currentQuestionBlock,
          'choices': currentChoicesBlock,
        });
      }

      return quizItems;
    }

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      contentPadding: const EdgeInsets.all(24),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Quiz Input Method',
              style: TextStyle(
                fontSize: titleSize ?? 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      debugPrint('Scan Quiz Image');
                      final quizData = await pickImage();

                      if (!context.mounted) return;

                      Navigator.pop(context);

                      if (quizData.isNotEmpty) {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder:
                              (_) => QuizDialog(
                                quizItems: quizData,
                                quizTitleSize: quizTitleSize,
                                quizHintSize: quizHintSize,
                                quizLabelSize: quizLabelSize,
                                quizButtonStyle: quizButtonStyle,
                              ),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.image_search, size: iconSize ?? 40),
                          const SizedBox(height: 8),
                          Text(
                            'Scan Image',
                            style: TextStyle(fontSize: subtitleSize),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.pop(context);

                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder:
                            (_) => QuizDialog(
                              quizTitleSize: quizTitleSize,
                              quizHintSize: quizHintSize,
                              quizLabelSize: quizLabelSize,
                              quizButtonStyle: quizButtonStyle,
                            ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.edit_note, size: iconSize ?? 40),
                          const SizedBox(height: 8),
                          Text(
                            'Manual',
                            style: TextStyle(fontSize: subtitleSize),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QuizDialog extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>>? quizItems;
  final double? quizTitleSize;
  final double? quizHintSize;
  final double? quizLabelSize;
  final List<double>? quizButtonStyle;

  const QuizDialog({
    super.key,
    this.quizItems,
    this.quizTitleSize,
    this.quizHintSize,
    this.quizLabelSize,
    this.quizButtonStyle,
  });

  @override
  ConsumerState<QuizDialog> createState() => _QuizDialogState();
}

class _QuizDialogState extends ConsumerState<QuizDialog> {
  final questionController = TextEditingController();
  final aController = TextEditingController();
  final bController = TextEditingController();
  final cController = TextEditingController();
  final dController = TextEditingController();
  final answerController = TextEditingController();

  int _currentIndex = 0;
  bool _isChoiceDVisible = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentQuizItem();
  }

  void _loadCurrentQuizItem() {
    if (widget.quizItems != null && widget.quizItems!.isNotEmpty) {
      if (_currentIndex < widget.quizItems!.length) {
        final currentItem = widget.quizItems![_currentIndex];
        final List<dynamic> choices = currentItem['choices'] ?? [];

        questionController.text = currentItem['question'] ?? '';
        aController.text = choices.isNotEmpty ? choices[0] : '';
        bController.text = choices.length > 1 ? choices[1] : '';
        cController.text = choices.length > 2 ? choices[2] : '';
        dController.text = choices.length > 3 ? choices[3] : '';

        _isChoiceDVisible = choices.length > 3;
        answerController.clear();
      }
    } else {
      _isChoiceDVisible = false;
    }
  }

  @override
  void dispose() {
    questionController.dispose();
    aController.dispose();
    bController.dispose();
    cController.dispose();
    dController.dispose();
    answerController.dispose();
    super.dispose();
  }

  int getAnswerIndex(String answer) {
    switch (answer.toUpperCase()) {
      case 'A':
        return 0;
      case 'B':
        return 1;
      case 'C':
        return 2;
      case 'D':
        return 3;
      default:
        return 0;
    }
  }

  bool get _hasMoreItems {
    if (widget.quizItems == null) return false;
    return _currentIndex < widget.quizItems!.length - 1;
  }

  void _saveCurrentToDraft() {
    final notifier = ref.read(materialDraftProvider.notifier);

    final allChoices = [
      QuizChoice(choice: aController.text.trim(), letter: "A"),
      QuizChoice(choice: bController.text.trim(), letter: "B"),
      QuizChoice(choice: cController.text.trim(), letter: "C"),
    ];

    if (_isChoiceDVisible) {
      allChoices.add(QuizChoice(choice: dController.text.trim(), letter: "D"));
    }

    final validChoices = allChoices.where((c) => c.choice.isNotEmpty).toList();

    notifier.addQuestion(
      QuizQuestionDraft(
        question: questionController.text.trim(),
        choices: validChoices,
        correctAnswer: getAnswerIndex(answerController.text).toString(),
      ),
    );
  }

  void _clearFieldsForNewQuestion() {
    questionController.clear();
    aController.clear();
    bController.clear();
    cController.clear();
    dController.clear();
    answerController.clear();
    setState(() {
      _isChoiceDVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasItems = widget.quizItems != null && widget.quizItems!.isNotEmpty;

    final String titleText =
        hasItems
            ? 'Add Quiz Question (${_currentIndex + 1} of ${widget.quizItems!.length})'
            : 'Add Quiz Question';

    debugPrint(
      'QuizData: ${[widget.quizTitleSize, widget.quizHintSize, widget.quizLabelSize]}',
    );

    return AlertDialog(
      title: Text(titleText, style: TextStyle(fontSize: widget.quizTitleSize)),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                decoration: InputDecoration(
                  hintText: 'Question',
                  hintStyle: TextStyle(fontSize: widget.quizHintSize),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: aController,
                decoration: InputDecoration(
                  hintText: 'Choice A',
                  hintStyle: TextStyle(fontSize: widget.quizHintSize),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: bController,
                decoration: InputDecoration(
                  hintText: 'Choice B',
                  hintStyle: TextStyle(fontSize: widget.quizHintSize),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: cController,
                decoration: InputDecoration(
                  hintText: 'Choice C',
                  hintStyle: TextStyle(fontSize: widget.quizHintSize),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              if (_isChoiceDVisible) ...[
                TextField(
                  controller: dController,
                  decoration: InputDecoration(
                    hintText: 'Choice D',
                    hintStyle: TextStyle(fontSize: widget.quizHintSize),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
              ] else ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _isChoiceDVisible = true;
                      });
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(
                      'Add Choice D',
                      style: TextStyle(fontSize: widget.quizLabelSize),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],

              TextField(
                controller: answerController,
                decoration: InputDecoration(
                  hintText: 'Correct Answer (A/B/C/D)',
                  hintStyle: TextStyle(fontSize: widget.quizHintSize),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!hasItems)
                    TextButton.icon(
                      onPressed: () {
                        if (questionController.text.trim().isNotEmpty) {
                          _saveCurrentToDraft();
                          _clearFieldsForNewQuestion();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Question saved to draft!'),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.add_box),
                      label: Text(
                        'New Question',
                        style: TextStyle(fontSize: widget.quizLabelSize),
                      ),
                    )
                  else
                    const SizedBox.shrink(),

                  CustomButton(
                    title: _hasMoreItems ? 'Next' : 'Submit',
                    size: 80,
                    radius: widget.quizButtonStyle?[0],
                    tSize: widget.quizButtonStyle?[1],
                    pad: widget.quizButtonStyle?[2],
                    onTap: () async {
                      _saveCurrentToDraft();

                      if (_hasMoreItems) {
                        setState(() {
                          _currentIndex++;
                          _loadCurrentQuizItem();
                        });
                      } else {
                        final draft = ref.read(materialDraftProvider);
                        final userRole = await ref.read(
                          userRoleProvider.future,
                        );
                        final gradeLevels = await ref.read(
                          gradeLevelUnfilteredProvider.future,
                        );

                        await saveReadingMaterial(
                          draft: draft,
                          userRole: userRole,
                          gradeLevels: gradeLevels,
                        );

                        if (context.mounted) {
                          Navigator.pop(context);

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return Dialog(
                                child: Container(
                                  width: 400,
                                  height: 250,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.surfaceContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Center(
                                      child: Text(
                                        'Material Added Successfully!\n\nIt will be reviewed by the admin and will appear in the list once approved.`',
                                        style: TextStyle(fontSize: 22),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> saveReadingMaterial({
  required ReadingMaterialDraft draft,
  required UserRole userRole,
  required List<GradeLevel> gradeLevels,
}) async {
  final supabase = Supabase.instance.client;
  final userSchoolId = userRole.schoolId;

  debugPrint('draft.gradeLevelId = ${draft.gradeLevelId}');

  for (final g in gradeLevels) {
    debugPrint('gradeNumber=${g.gradeNumber}, gradeLevelId=${g.gradeLevelId}');
  }

  final gradeLevel = gradeLevels.firstWhere(
    (g) => g.gradeNumber.toString() == draft.gradeLevelId,
    orElse:
        () => throw Exception('Invalid grade selected: ${draft.gradeLevelId}'),
  );

  debugPrint('grIdx: ${gradeLevel.gradeLevelId}');
  final story =
      await supabase
          .from('stories')
          .insert({
            'title': draft.title,
            'content': draft.content,
            'word_count': draft.wordCount,
            'language': draft.language,
            'grade_level_id': gradeLevel.gradeLevelId,
            'created_by': supabase.auth.currentUser!.id,
          })
          .select()
          .single();

  final storyId = story['story_id'];

  final quiz =
      await supabase
          .from('quizzes')
          .insert({
            'total_score': draft.questions.length,
            'created_by': supabase.auth.currentUser!.id,
          })
          .select()
          .single();

  final quizId = quiz['quiz_id'];

  await supabase
      .from('quiz_questions')
      .insert(
        draft.questions
            .asMap()
            .entries
            .map(
              (entry) => {
                'quiz_id': quizId,
                'question_text': entry.value.question,
                'choices': entry.value.choices,
                'correct_answer': entry.value.correctAnswer,
                'question_order': entry.key + 1,
              },
            )
            .toList(),
      );

  await supabase.from('reading_materials').insert({
    'title': draft.title,
    'language': draft.language,
    'word_count': draft.wordCount,
    'grade_level_id': gradeLevel.gradeLevelId,
    'story_id': storyId,
    'quiz_id': quizId,
    'status': 'pending',
    'uploaded_by': supabase.auth.currentUser!.id,
    'school_id': userSchoolId,
  });
}
