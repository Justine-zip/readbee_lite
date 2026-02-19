import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTap;
  final double? size;
  final String title;
  const CustomButton({
    super.key,
    required this.onTap,
    required this.title,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: size ?? double.infinity,
          padding: EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(title, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
