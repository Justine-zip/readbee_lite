import 'package:flutter/material.dart';
import 'package:readbee_lite/components/custom_button.dart';

class PromptBox extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  final double? contPad;
  final double? titleSize;
  final double? subtitleSize;
  final List<double>? buttonStyle;

  const PromptBox({
    super.key,
    required this.title,
    this.subtitle,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,

    this.contPad,
    this.titleSize,
    this.subtitleSize,
    this.buttonStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      insetPadding: EdgeInsets.all(contPad ?? 20),
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: titleSize ?? 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (subtitle != null) ...[
                Text(
                  subtitle ?? '',
                  style: TextStyle(fontSize: subtitleSize ?? 20),
                ),
                const SizedBox(height: 30),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    onTap: onCancel,
                    title: cancelText ?? 'Not Yet',
                    tSize: buttonStyle?[0],
                    pad: buttonStyle?[2],
                    size: buttonStyle?[3] ?? 150,
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    onTap: onConfirm,
                    title: confirmText ?? 'Submit',
                    tSize: buttonStyle?[1],
                    pad: buttonStyle?[2],
                    size: buttonStyle?[3] ?? 150,
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
