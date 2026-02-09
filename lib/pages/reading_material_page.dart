import 'package:flutter/material.dart';
import 'package:readbee_lite/components/custom_textfield.dart';

class ReadingMaterialPage extends StatefulWidget {
  const ReadingMaterialPage({super.key});

  @override
  State<ReadingMaterialPage> createState() => _ReadingMaterialPageState();
}

class _ReadingMaterialPageState extends State<ReadingMaterialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reading Materials',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomTextfield(hint: 'Search...'),
                Icon(Icons.filter_alt_rounded),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
