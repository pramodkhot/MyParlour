import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design/spacing.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/feedback.dart';
import '../../../domain/errors.dart';
import '../../../domain/models/customer.dart';
import '../customers_controller.dart';

/// Editable notes, saved with a button.
class CustomerNotesTab extends ConsumerStatefulWidget {
  const CustomerNotesTab({super.key, required this.customer});

  final Customer customer;

  @override
  ConsumerState<CustomerNotesTab> createState() => _CustomerNotesTabState();
}

class _CustomerNotesTabState extends ConsumerState<CustomerNotesTab> {
  late final _controller = TextEditingController(
    text: widget.customer.notes ?? '',
  );
  bool _saving = false;

  bool get _changed =>
      _controller.text.trim() != (widget.customer.notes ?? '').trim();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref
          .read(customerActionsProvider)
          .updateNotes(widget.customer, _controller.text);
      if (mounted) {
        FocusScope.of(context).unfocus();
        showMessage(context, 'Notes saved');
      }
    } on DomainException catch (e) {
      if (mounted) showMessage(context, e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(Space.screen),
      children: [
        TextField(
          controller: _controller,
          minLines: 5,
          maxLines: 10,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            hintText:
                'Preferences, allergies, favourite stylist… '
                '(e.g. Prefers less heat in smoothening)',
          ),
        ),
        Gap.h16,
        PrimaryButton(
          label: 'Save notes',
          loading: _saving,
          onPressed: _changed ? _save : null,
        ),
      ],
    );
  }
}
