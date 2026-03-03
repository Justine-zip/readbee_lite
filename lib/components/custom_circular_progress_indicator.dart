import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final double value;
  const CustomCircularProgressIndicator({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: SizedBox(
            width: 70,
            height: 70,
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
            style: TextStyle(fontSize: 22),
          ),
        ),
      ],
    );
  }
}
