import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String hint;
  const CustomTextfield({super.key, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .6,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(decoration: InputDecoration(hintText: hint)),
      ),
    );
  }
}
