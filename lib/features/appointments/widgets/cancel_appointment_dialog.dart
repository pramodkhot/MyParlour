import 'package:flutter/material.dart';

import '../../../core/design/colors.dart';
import '../../../core/design/spacing.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/choice_chips.dart';

/// Quick reasons in the current language. The chosen one is saved as the
/// cancel reason, like a typed one.
List<String> _quickReasons(AppLocalizations l10n) => [
  l10n.apptReasonCustomerCancelled,
  l10n.apptReasonCustomerUnwell,
  l10n.apptReasonRescheduledByCustomer,
  l10n.apptReasonStylistUnavailable,
];

/// Asks why the appointment is cancelled. Resolves to the reason (may be
/// empty), or null if the user keeps the appointment.
Future<String?> showCancelAppointmentDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (_) => const _CancelDialog(),
  );
}

class _CancelDialog extends StatefulWidget {
  const _CancelDialog();

  @override
  State<_CancelDialog> createState() => _CancelDialogState();
}

class _CancelDialogState extends State<_CancelDialog> {
  final _controller = TextEditingController();
  String? _quick;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.apptCancelTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.apptCancelReasonLabel),
            Gap.h12,
            ChoiceChips<String>(
              options: [
                for (final r in _quickReasons(l10n)) ChoiceOption(r, r),
              ],
              selected: _quick,
              onSelected: (r) => setState(() {
                _quick = r;
                _controller.text = r;
              }),
            ),
            Gap.h12,
            TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(hintText: l10n.apptCancelReasonHint),
              onChanged: (_) => setState(() => _quick = null),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(foregroundColor: AppColors.textMuted),
          child: Text(l10n.apptCancelKeep),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: Text(l10n.apptCancelAppointment),
        ),
      ],
    );
  }
}
