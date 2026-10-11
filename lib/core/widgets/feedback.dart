import 'package:flutter/material.dart';

/// Shows a short message at the bottom of the screen.
void showMessage(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        // Float above a screen's bottom action buttons (54 high plus
        // padding) so a message never covers "Check in" or "Save".
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 88),
      ),
    );
}
