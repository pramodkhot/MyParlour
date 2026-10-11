import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design/colors.dart';
import '../../../core/design/spacing.dart';
import '../../../core/design/typography.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/choice_chips.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/field_label.dart';
import '../../../core/widgets/qty_stepper.dart';
import '../../../domain/errors.dart';
import '../../../domain/models/product.dart';
import '../../../domain/services/stock_rules.dart';
import '../inventory_controller.dart';

/// "Adjust stock": type, quantity and a note.
Future<void> showAdjustStockSheet(BuildContext context, Product product) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: _AdjustSheet(product: product),
    ),
  );
}

class _AdjustSheet extends ConsumerStatefulWidget {
  const _AdjustSheet({required this.product});

  final Product product;

  @override
  ConsumerState<_AdjustSheet> createState() => _AdjustSheetState();
}

class _AdjustSheetState extends ConsumerState<_AdjustSheet> {
  StockAdjustment _type = StockAdjustment.stockIn;
  late int _qty = 1;
  final _note = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  int get _change =>
      _type.changeFor(quantity: _qty, currentStock: widget.product.stockQty);

  String? get _error {
    final next = widget.product.stockQty + _change;
    if (next < 0) {
      return context.l10n.inventoryOnlyInStock(widget.product.stockQty);
    }
    if (_change == 0) return context.l10n.inventorySameAsCurrent;
    return null;
  }

  void _setType(StockAdjustment t) => setState(() {
    _type = t;
    // A count starts from the current stock; the others from 1.
    _qty = t == StockAdjustment.countCorrection ? widget.product.stockQty : 1;
  });

  Future<void> _save() async {
    if (_saving || _error != null) return;
    setState(() => _saving = true);
    final navigator = Navigator.of(context);
    try {
      await ref
          .read(productActionsProvider)
          .adjust(
            widget.product.id,
            qtyChange: _change,
            reason: _type.reason,
            note: _note.text,
          );
      if (!mounted) return;
      showMessage(context, context.l10n.inventoryStockUpdated);
      navigator.pop();
    } on DomainException catch (e) {
      if (mounted) {
        showMessage(context, context.errorText(e));
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final p = widget.product;
    final unit = l10n.unit(p.unit);
    final next = p.stockQty + _change;
    final error = _error;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.inventoryAdjustStock, style: AppText.barTitle),
            Text(
              l10n.inventoryAdjustSubtitle(p.name, p.stockQty, unit),
              style: AppText.caption,
            ),
            Gap.h16,
            FieldLabel(l10n.inventoryAdjustType, required: true),
            Gap.h8,
            ChoiceChips<StockAdjustment>(
              options: [
                for (final t in StockAdjustment.values)
                  ChoiceOption(t, l10n.stockAdjustment(t)),
              ],
              selected: _type,
              onSelected: _setType,
            ),
            Gap.h16,
            FieldLabel(
              _type == StockAdjustment.countCorrection
                  ? l10n.inventoryCountedQty
                  : l10n.inventoryQty,
              required: true,
            ),
            Gap.h8,
            Row(
              children: [
                QtyStepper(
                  value: _qty,
                  min: _type == StockAdjustment.countCorrection ? 0 : 1,
                  onChanged: (q) => setState(() => _qty = q),
                ),
                Gap.w16,
                Expanded(
                  child: Text(
                    error ?? l10n.inventoryNewStock(next, unit),
                    style: AppText.body.copyWith(
                      color: error == null
                          ? AppColors.success
                          : AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Gap.h16,
            AppTextField(
              label: l10n.inventoryNote,
              controller: _note,
              hint: l10n.inventoryNoteHint,
              textCapitalization: TextCapitalization.sentences,
            ),
            Gap.h20,
            PrimaryButton(
              label: l10n.commonSave,
              loading: _saving,
              onPressed: error == null ? _save : null,
            ),
          ],
        ),
      ),
    );
  }
}
