import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

void showGlobalSnackBar(String message) {
  final snackBar = SnackBar(
    content: Text(message),
    behavior: SnackBarBehavior.floating,
  );

  snackbarKey.currentState?.clearSnackBars();

  snackbarKey.currentState?.showSnackBar(snackBar);
}
