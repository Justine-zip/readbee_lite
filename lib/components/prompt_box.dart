import 'package:flutter/material.dart';
import 'package:readbee_lite/components/custom_button.dart';

class PromptBox extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const PromptBox({
    super.key,
    required this.title,
    this.subtitle,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      insetPadding: const EdgeInsets.all(20),
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (subtitle != null) ...[
                Text(subtitle ?? '', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 30),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    onTap: onCancel,
                    title: cancelText ?? 'Not Yet',
                    size: 150,
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    onTap: onConfirm,
                    title: confirmText ?? 'Submit',
                    size: 150,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
