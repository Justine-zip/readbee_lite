import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTap;
  final double? size;
  final double? vertSize;
  final double? radius;
  final double? pad;
  final double? tSize;
  final double? border;
  final String title;
  final Color? boxColor;
  final Color? textColor;
  const CustomButton({
    super.key,
    required this.onTap,
    required this.title,
    this.size,
    this.vertSize,
    this.radius,
    this.pad,
    this.border,
    this.tSize,
    this.boxColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onTap == null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(radius ?? 12),
        child: Container(
          width: size ?? double.infinity,
          height: vertSize,
          padding: EdgeInsets.symmetric(vertical: pad ?? 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color:
                isDisabled ? Colors.grey.shade400 : (boxColor ?? Colors.amber),
            borderRadius: BorderRadius.circular(radius ?? 12),
            border: Border.all(width: border ?? 0),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: tSize ?? 18,
              color:
                  isDisabled
                      ? Colors.grey.shade700
                      : (textColor ?? Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
