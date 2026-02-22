import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final double radius;
  final Color color;
  final Function()? onTap;
  final double iconSize;
  final Color iconColor;
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.radius,
    required this.color,
    required this.onTap,
    required this.iconSize,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: color,
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, size: iconSize, color: iconColor),
      ),
    );
  }
}
