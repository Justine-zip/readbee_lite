import 'package:flutter/material.dart';

class CustomReadingScoreRow extends StatelessWidget {
  final String title;
  final String value;

  final double? titleSize;
  final double? valueSize;
  const CustomReadingScoreRow({
    super.key,
    required this.title,
    required this.value,

    this.titleSize,
    this.valueSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: titleSize ?? 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: valueSize ?? 28,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
