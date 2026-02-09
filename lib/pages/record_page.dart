import 'package:flutter/material.dart';
import 'package:readbee_lite/components/record_list_builder.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Class Record',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 60),
            Text(
              'Select Grade Level',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            RecordListBuilder(
              onTap: (level) => debugPrint('Print Grade $level'),
            ),
          ],
        ),
      ),
    );
  }
}
