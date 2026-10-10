import 'package:flutter/material.dart';

import 'confirm_dialog.dart';

/// Asks "Discard changes?" when the user leaves a form with unsaved edits
/// (system Back, app-bar back, or swipe).
class DiscardChangesScope extends StatelessWidget {
  const DiscardChangesScope({
    super.key,
    required this.isDirty,
    required this.child,
  });

  final bool isDirty;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: !isDirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        final discard = await ConfirmDialog.show(
          context,
          title: 'Discard changes?',
          message: 'What you entered on this screen will not be saved.',
          confirmLabel: 'Discard',
          cancelLabel: 'Keep editing',
          destructive: true,
        );
        if (discard && navigator.mounted) navigator.pop();
      },
      child: child,
    );
  }
}
