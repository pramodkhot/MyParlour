import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
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
        final l10n = context.l10n;
        final discard = await ConfirmDialog.show(
          context,
          title: l10n.discardTitle,
          message: l10n.discardMessage,
          confirmLabel: l10n.discardConfirm,
          cancelLabel: l10n.discardKeep,
          destructive: true,
        );
        if (discard && navigator.mounted) navigator.pop();
      },
      child: child,
    );
  }
}
