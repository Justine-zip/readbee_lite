import 'package:flutter/material.dart';
import 'package:readbee_lite/components/custom_button.dart';

class PromptBox extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onConfirm;

  const PromptBox({
    super.key,
    required this.title,
    this.subtitle,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      insetPadding: EdgeInsets.all(20),
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (subtitle != null) ...[
                Text(subtitle ?? '', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 30),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    onTap: () => Navigator.pop(context),
                    title: 'Not Yet',
                    size: 150,
                  ),
                  SizedBox(width: 10),
                  CustomButton(onTap: onConfirm, title: 'Submit', size: 150),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
