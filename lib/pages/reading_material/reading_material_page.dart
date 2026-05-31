import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/components/custom_textfield.dart';
import 'package:readbee_lite/components/filter_sheet.dart';
import 'package:readbee_lite/components/reading_material_builder.dart';
import 'package:readbee_lite/components/title_bar.dart';
import 'package:readbee_lite/models/grade_level.dart';
import 'package:readbee_lite/models/material_draft.dart';
import 'package:readbee_lite/models/user_role.dart';
import 'package:readbee_lite/providers/comprehension_provider.dart';
import 'package:readbee_lite/providers/evaluation_list_provider.dart';
import 'package:readbee_lite/providers/grade_level_provider.dart';
import 'package:readbee_lite/providers/material_draft_provider.dart';
import 'package:readbee_lite/providers/material_filter_provider.dart';
import 'package:readbee_lite/providers/miscue_content_provider.dart';
import 'package:readbee_lite/providers/miscue_provider.dart';
import 'package:readbee_lite/providers/timer_provider.dart';
import 'package:readbee_lite/providers/user_role_provider.dart';
import 'package:readbee_lite/providers/word_color_provider.dart';
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

class StoryDialog extends ConsumerStatefulWidget {
  const StoryDialog({super.key});

  @override
  ConsumerState<StoryDialog> createState() => _StoryDialogState();
}

class _StoryDialogState extends ConsumerState<StoryDialog> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final gradeController = TextEditingController();
  final wordController = TextEditingController();
  final languageController = TextEditingController();

  @override
  void dispose() {
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
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                height: 200,
                child: TextField(
                  controller: contentController,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    hintText: 'Story Content',
                    border: OutlineInputBorder(),
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
                  hint: const Text('Select Grade Level'),
                  items: const [
                    DropdownMenuItem(value: '3', child: Text('Grade 3')),
                    DropdownMenuItem(value: '4', child: Text('Grade 4')),
                    DropdownMenuItem(value: '5', child: Text('Grade 5')),
                    DropdownMenuItem(value: '6', child: Text('Grade 6')),
                  ],
                  onChanged: (value) {
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
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Words',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: TextField(
                      controller: languageController,
                      decoration: const InputDecoration(
                        hintText: 'Language',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Align(
                alignment: Alignment.bottomRight,
                child: CustomButton(
                  title: 'Next',
                  size: 100,
                  onTap: () {
                    notifier.setTitle(titleController.text);

                    notifier.setContent(contentController.text);

                    notifier.setWordCount(
                      int.tryParse(wordController.text) ?? 0,
                    );

                    notifier.setLanguage(languageController.text);

                    Navigator.pop(context);

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const QuizDialog(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizDialog extends ConsumerStatefulWidget {
  const QuizDialog({super.key});

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

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(materialDraftProvider.notifier);

    return AlertDialog(
      title: const Text('Add Quiz Question'),
      backgroundColor: Colors.white,
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: questionController,
              decoration: const InputDecoration(
                hintText: 'Question',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: aController,
              decoration: const InputDecoration(
                hintText: 'Choice A',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: bController,
              decoration: const InputDecoration(
                hintText: 'Choice B',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: cController,
              decoration: const InputDecoration(
                hintText: 'Choice C',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: dController,
              decoration: const InputDecoration(
                hintText: 'Choice D',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: answerController,
              decoration: const InputDecoration(
                hintText: 'Correct Answer (A/B/C/D)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.bottomRight,
              child: CustomButton(
                title: 'Submit',
                size: 100,
                onTap: () async {
                  notifier.addQuestion(
                    QuizQuestionDraft(
                      question: questionController.text,
                      choices: [
                        QuizChoice(choice: aController.text, letter: "A"),
                        QuizChoice(choice: bController.text, letter: "B"),
                        QuizChoice(choice: cController.text, letter: "C"),
                        QuizChoice(choice: dController.text, letter: "D"),
                      ],
                      correctAnswer:
                          getAnswerIndex(answerController.text).toString(),
                    ),
                  );

                  final draft = ref.read(materialDraftProvider);
                  final userRole = await ref.read(userRoleProvider.future);
                  final gradeLevels = await ref.read(
                    gradeLevelUnfilteredProvider.future,
                  );

                  await saveReadingMaterial(
                    draft: draft,
                    userRole: userRole,
                    gradeLevels: gradeLevels,
                  );

                  Navigator.pop(context);
                },
              ),
            ),
          ],
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
    'status': 'draft',
    'uploaded_by': supabase.auth.currentUser!.id,
    'school_id': userSchoolId,
  });
}
