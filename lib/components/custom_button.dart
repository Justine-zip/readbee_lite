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
    final bool isDisabled = onTap == null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: size ?? double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDisabled ? Colors.grey.shade400 : Colors.amber,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: isDisabled ? Colors.grey.shade700 : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
