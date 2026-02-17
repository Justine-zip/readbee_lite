import 'package:flutter/material.dart';

class ProfileGeneralOption extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final bool isToggle;
  final bool value;
  final double size;
  const ProfileGeneralOption({
    super.key,
    required this.title,
    required this.onTap,
    this.isToggle = false,
    this.value = false,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: size, fontWeight: FontWeight.bold),
              ),
              isToggle
                  ? Switch(
                    focusColor: Theme.of(context).colorScheme.primary,
                    value: value,
                    onChanged: (_) {
                      if (onTap != null) onTap!();
                    },
                  )
                  : Icon(Icons.arrow_forward_ios_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
