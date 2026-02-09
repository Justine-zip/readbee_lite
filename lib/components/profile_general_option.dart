import 'package:flutter/material.dart';

class ProfileGeneralOption extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final bool isToggle;
  final bool value;
  const ProfileGeneralOption({
    super.key,
    required this.title,
    required this.onTap,
    this.isToggle = false,
    this.value = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              isToggle
                  ? Switch(value: value, onChanged: (value) {})
                  : Icon(Icons.arrow_forward_ios_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
