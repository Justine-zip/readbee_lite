import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final double value;
  final double? size;
  final double? tSize;
  const CustomCircularProgressIndicator({
    super.key,
    required this.value,
    this.size,
    this.tSize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: SizedBox(
            width: size ?? 70,
            height: size ?? 70,
            child: CircularProgressIndicator(
              color: Colors.amber,
              value: value,
              strokeWidth: 5,
            ),
          ),
        ),
        Center(
          child: Text(
            '${(value * 100).toInt()}%',
            style: TextStyle(fontSize: tSize ?? 22),
          ),
        ),
      ],
    );
  }
}
