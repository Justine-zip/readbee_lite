import 'package:flutter/material.dart';
import 'package:readbee_lite/components/record_list_builder.dart';

enum RecordStep { grade, section, language }

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  RecordStep currentStep = RecordStep.grade;

  int? selectedGrade;
  int? selectedSection;

  void goBack() {
    setState(() {
      if (currentStep == RecordStep.language) {
        currentStep = RecordStep.section;
      } else if (currentStep == RecordStep.section) {
        currentStep = RecordStep.grade;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String title;
    String listTitle;

    switch (currentStep) {
      case RecordStep.grade:
        title = 'Grade Level';
        listTitle = 'Grade';
        break;

      case RecordStep.section:
        title = 'Section (Grade $selectedGrade)';
        listTitle = 'Section';
        break;

      case RecordStep.language:
        title = 'Language (G$selectedGrade • S$selectedSection)';
        listTitle = 'Language';
        break;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),

            const Text(
              'Class Record',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 48,
                  height: 48,
                  child:
                      currentStep != RecordStep.grade
                          ? IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: goBack,
                          )
                          : null,
                ),
              ],
            ),

            RecordListBuilder(
              title: listTitle,
              onTap: (value) {
                setState(() {
                  if (currentStep == RecordStep.grade) {
                    selectedGrade = value;
                    currentStep = RecordStep.section;
                  } else if (currentStep == RecordStep.section) {
                    selectedSection = value;
                    currentStep = RecordStep.language;
                  } else {
                    debugPrint(
                      'Grade $selectedGrade | Section $selectedSection | Language $value',
                    );
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
