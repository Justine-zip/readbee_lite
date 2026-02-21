import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/components/title_bar.dart';
import 'package:readbee_lite/models/reading_material.dart';
import 'package:readbee_lite/models/section.dart';
import 'package:readbee_lite/models/student.dart';
import 'package:readbee_lite/providers/evaluation_list_provider.dart';

class ReadingMaterialDetailsPage extends StatefulWidget {
  final List<ReadingMaterial> material;
  const ReadingMaterialDetailsPage({super.key, required this.material});

  @override
  State<ReadingMaterialDetailsPage> createState() =>
      _ReadingMaterialDetailsPageState();
}

class _ReadingMaterialDetailsPageState
    extends State<ReadingMaterialDetailsPage> {
  String sectionId = '1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TitleBar(
              title: widget.material[0].title,
              description:
                  'Bilang ng mga salita: ${widget.material[0].wordLength}',
              secondDescription: 'Language: ${widget.material[0].language}',
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Material(
                      elevation: 3,
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        topLeft: Radius.circular(12),
                      ),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * .675,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  widget.material[0].title,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  widget.material[0].content,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 24),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
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
                                  itemCount: widget.material[0].question.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.material[0].question[index],
                                          style: TextStyle(fontSize: 22),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              for (var key
                                                  in widget
                                                      .material[0]
                                                      .key[index]
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

                              CustomButton(
                                onTap: () {
                                  debugPrint('Tapped');
                                  evaluationList(context);
                                },
                                title: 'Proceed',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> evaluationList(BuildContext context) {
    return showDialog(context: context, builder: (_) => EvaluationListDialog());
  }
}

class EvaluationListDialog extends ConsumerWidget {
  EvaluationListDialog({super.key});

  final List<Section> sections = [
    Section(section: 'Sampaguita', sectionId: '1'),
    Section(section: 'Tulips', sectionId: '2'),
    Section(section: 'Rosas', sectionId: '3'),
    Section(section: 'Emerald', sectionId: '4'),
    Section(section: 'Ilang-Ilang', sectionId: '5'),
  ];

  final List<Student> student = [
    Student(
      name: 'Denmark Cabanhao',
      lrn: '0121',
      sectionId: '1',
      studentId: '1',
    ),
    Student(name: 'Romeo Ezguera', lrn: '0740', sectionId: '1', studentId: '2'),
    Student(name: 'Kori Sanchez', lrn: '0321', sectionId: '1', studentId: '3'),
    Student(name: 'Bill Fraud', lrn: '0353', sectionId: '2', studentId: '4'),
    Student(
      name: 'Juan Dela Cruz',
      lrn: '0586',
      sectionId: '2',
      studentId: '5',
    ),
    Student(name: 'Ezra Ramirez', lrn: '0835', sectionId: '3', studentId: '6'),
    Student(name: 'Tanya Suami', lrn: '0035', sectionId: '3', studentId: '7'),
    Student(
      name: 'Ralph Angsioco',
      lrn: '0655',
      sectionId: '3',
      studentId: '8',
    ),
    Student(name: 'Paolo Bentir', lrn: '0397', sectionId: '3', studentId: '9'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(evaluationProvider);
    final notifier = ref.read(evaluationProvider.notifier);

    final filteredStudents = notifier.filteredStudents(student);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .5,
        width: MediaQuery.of(context).size.width * .4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          const Text(
                            "Section List",
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: sections.length,
                              itemBuilder: (context, index) {
                                final section = sections[index];

                                return ListTile(
                                  selected:
                                      state.selectedSectionId ==
                                      section.sectionId,
                                  selectedTileColor: Colors.amber.withOpacity(
                                    .3,
                                  ),
                                  title: Text(section.section),
                                  onTap: () {
                                    notifier.selectSection(section.sectionId);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const VerticalDivider(thickness: 4),

                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          const Text(
                            "Student List",
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredStudents.length,
                              itemBuilder: (context, index) {
                                final studentItem = filteredStudents[index];

                                return ListTile(
                                  selected:
                                      state.selectedStudent == studentItem,
                                  selectedTileColor: Colors.amber.withOpacity(
                                    .3,
                                  ),
                                  title: Text(studentItem.name),
                                  onTap: () {
                                    notifier.selectStudent(studentItem);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CustomButton(
                    onTap:
                        state.selectedStudent == null
                            ? null
                            : notifier.evaluate,
                    title: 'Evaluate',
                    size: 150,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
