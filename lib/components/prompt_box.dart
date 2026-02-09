import 'package:flutter/material.dart';

class PromptBox extends StatelessWidget {
  final String title;
  final VoidCallback? onConfirm;

  const PromptBox({super.key, required this.title, this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm?.call();
            Navigator.pop(context);
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
