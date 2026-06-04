import 'package:flutter/material.dart';

class CustomStoryContainer extends StatelessWidget {
  final String title;
  final double? tSize;
  final double? pad;
  const CustomStoryContainer({
    super.key,
    required this.title,
    this.tSize,
    this.pad,
  });

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
            color: Theme.of(context).colorScheme.surfaceContainer,
          ),
          child: Padding(
            padding: EdgeInsets.all(pad ?? 24.0),
            child: Text(title, style: TextStyle(fontSize: tSize ?? 24)),
          ),
        ),
      ),
    );
  }
}
