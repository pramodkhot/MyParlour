import 'package:flutter/material.dart';

import '../../../core/design/colors.dart';
import '../../../core/design/spacing.dart';
import '../../../core/widgets/choice_chips.dart';

const _quickReasons = [
  'Customer cancelled',
  'Customer unwell',
  'Rescheduled by customer',
  'Stylist unavailable',
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
    return AlertDialog(
      title: const Text('Cancel appointment?'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Reason (optional)'),
            Gap.h12,
            ChoiceChips<String>(
              options: [for (final r in _quickReasons) ChoiceOption(r, r)],
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
              decoration: const InputDecoration(hintText: 'Or type a reason'),
              onChanged: (_) => setState(() => _quick = null),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(foregroundColor: AppColors.textMuted),
          child: const Text('Keep it'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: const Text('Cancel appointment'),
        ),
      ],
    );
  }
}
