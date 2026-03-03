import 'package:flutter/material.dart';

class CustomStoryContainer extends StatelessWidget {
  final String title;
  const CustomStoryContainer({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(title, style: TextStyle(fontSize: 24)),
          ),
        ),
      ),
    );
  }
}
