import 'package:flutter/material.dart';
import 'package:readbee_lite/components/custom_button.dart';
import 'package:readbee_lite/components/title_bar.dart';
import 'package:readbee_lite/models/reading_material.dart';
import 'package:readbee_lite/models/section.dart';
import 'package:readbee_lite/models/student.dart';

class ReadingMaterialDetailsPage extends StatefulWidget {
  final List<ReadingMaterial> material;
  const ReadingMaterialDetailsPage({super.key, required this.material});

  @override
  State<ReadingMaterialDetailsPage> createState() =>
      _ReadingMaterialDetailsPageState();
}

class _ReadingMaterialDetailsPageState
    extends State<ReadingMaterialDetailsPage> {
  List<Section> sections = [
    Section(section: 'Sampaguita', sectionId: '1'),
    Section(section: 'Tulips', sectionId: '2'),
    Section(section: 'Rosas', sectionId: '3'),
    Section(section: 'Emerald', sectionId: '4'),
    Section(section: 'Ilang-Ilang', sectionId: '5'),
  ];

  List<Student> student = [
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
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      Function()? onTap;
                                      return StatefulBuilder(
                                        builder: (context, setDialogState) {
                                          final filteredStudents =
                                              student
                                                  .where(
                                                    (s) =>
                                                        s.sectionId ==
                                                        sectionId,
                                                  )
                                                  .toList();

                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Container(
                                              height:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  .5,
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  .4,
                                              padding: const EdgeInsets.all(20),
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
                                                                style:
                                                                    TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                    ),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Expanded(
                                                                child: ListView.builder(
                                                                  itemCount:
                                                                      sections
                                                                          .length,
                                                                  itemBuilder: (
                                                                    context,
                                                                    index,
                                                                  ) {
                                                                    return InkWell(
                                                                      onTap: () {
                                                                        setDialogState(() {
                                                                          sectionId =
                                                                              sections[index].sectionId;
                                                                        });
                                                                      },
                                                                      child: ListTile(
                                                                        title: Text(
                                                                          sections[index]
                                                                              .section,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        const VerticalDivider(
                                                          thickness: 4,
                                                          width: 20,
                                                        ),

                                                        Expanded(
                                                          flex: 4,
                                                          child: Column(
                                                            children: [
                                                              const Text(
                                                                "Student List",
                                                                style:
                                                                    TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                    ),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Expanded(
                                                                child: ListView.builder(
                                                                  itemCount:
                                                                      filteredStudents
                                                                          .length,
                                                                  itemBuilder: (
                                                                    context,
                                                                    index,
                                                                  ) {
                                                                    return InkWell(
                                                                      onTap: () {
                                                                        setDialogState(() {
                                                                          onTap = () {
                                                                            debugPrint(
                                                                              'FilteredStudent: ${filteredStudents[index].name}',
                                                                            );
                                                                          };
                                                                        });
                                                                      },
                                                                      child: ListTile(
                                                                        title: Text(
                                                                          filteredStudents[index]
                                                                              .name,
                                                                        ),
                                                                      ),
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
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            12.0,
                                                          ),
                                                      child: CustomButton(
                                                        onTap: onTap,
                                                        title: 'Evaluate',
                                                        size: 150,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
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
}
