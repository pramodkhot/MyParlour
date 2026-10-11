import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/money.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/choice_chips.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/discard_changes_scope.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/field_label.dart';
import '../../core/widgets/more_details.dart';
import '../../domain/errors.dart';
import '../../domain/models/product.dart';
import 'inventory_controller.dart';

/// S13 form — add or edit a product. [productId] null means "add".
class ProductFormScreen extends ConsumerWidget {
  const ProductFormScreen({super.key, this.productId});

  final String? productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = productId;
    if (id == null) return const _ProductForm();
    final detail = ref.watch(productDetailProvider(id));
    if (detail.value != null) {
      return _ProductForm(initial: detail.value!.product);
    }
    return Scaffold(
      appBar: const AppTopBar(title: 'Product'),
      body: Center(
        child: detail.isLoading
            ? const CircularProgressIndicator()
            : const EmptyState(
                icon: Icons.inventory_2_outlined,
                message: 'This product no longer exists.',
              ),
      ),
    );
  }
}

class _ProductForm extends ConsumerStatefulWidget {
  const _ProductForm({this.initial});

  final Product? initial;

  @override
  ConsumerState<_ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends ConsumerState<_ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late final Product? _p = widget.initial;
  late final _name = TextEditingController(text: _p?.name ?? '');
  late final _stock = TextEditingController(
    text: _p == null ? '' : '${_p.stockQty}',
  );
  late final _alert = TextEditingController(text: '${_p?.lowStockAt ?? 2}');
  late final _price = TextEditingController(
    text: _rupees(_p?.sellingPricePaise),
  );
  late final _cost = TextEditingController(text: _rupees(_p?.costPricePaise));
  late final _category = TextEditingController(text: _p?.category ?? '');
  late ProductUnit _unit = _p?.unit ?? ProductUnit.pcs;
  bool _saving = false;

  bool get _isEdit => _p != null;

  static String _rupees(int? paise) => paise == null
      ? ''
      : Money.format(paise).replaceAll('₹', '').replaceAll(',', '');

  List<TextEditingController> get _all => [
    _name,
    _stock,
    _alert,
    _price,
    _cost,
    _category,
  ];

  bool get _isDirty =>
      _name.text.trim() != (_p?.name ?? '') ||
      (!_isEdit && _stock.text.trim().isNotEmpty) ||
      _alert.text.trim() != '${_p?.lowStockAt ?? 2}' ||
      _price.text.trim() != _rupees(_p?.sellingPricePaise) ||
      _cost.text.trim() != _rupees(_p?.costPricePaise) ||
      _category.text.trim() != (_p?.category ?? '') ||
      _unit != (_p?.unit ?? ProductUnit.pcs);

  @override
  void initState() {
    super.initState();
    for (final c in _all) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in _all) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final actions = ref.read(productActionsProvider);
    String? blank(String s) => s.trim().isEmpty ? null : s.trim();
    try {
      await actions.save(
        Product(
          id: _p?.id ?? actions.newId(),
          parlourId: _p?.parlourId ?? '',
          name: _name.text.trim(),
          category: blank(_category.text),
          unit: _unit,
          sellingPricePaise: Money.parseRupees(_price.text),
          costPricePaise: Money.parseRupees(_cost.text),
          stockQty: _p?.stockQty ?? int.parse(_stock.text.trim()),
          lowStockAt: int.parse(_alert.text.trim()),
          isActive: _p?.isActive ?? true,
        ),
      );
      if (!mounted) return;
      showMessage(context, _isEdit ? 'Product updated' : 'Product added');
      Navigator.of(context).pop();
    } on DomainException catch (e) {
      if (mounted) showMessage(context, e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _toggleActive() async {
    final p = _p!;
    if (p.isActive) {
      final ok = await ConfirmDialog.show(
        context,
        title: 'Deactivate ${p.name}?',
        message:
            'It will no longer be offered on bills. Its stock history is kept.',
        confirmLabel: 'Deactivate',
        destructive: true,
      );
      if (!ok) return;
    }
    await ref
        .read(productActionsProvider)
        .setActive(p.id, isActive: !p.isActive);
    if (!mounted) return;
    showMessage(
      context,
      p.isActive ? 'Product deactivated' : 'Product reactivated',
    );
    Navigator.of(context).pop();
  }

  String? _wholeNumber(String? v, String what) {
    // Digits-only input, so the number can never be negative.
    return int.tryParse(v?.trim() ?? '') == null ? 'Enter $what.' : null;
  }

  String? _optionalMoney(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return null;
    return Money.parseRupees(t) == null ? 'Enter a price in rupees.' : null;
  }

  @override
  Widget build(BuildContext context) {
    final digits = [FilteringTextInputFormatter.digitsOnly];
    final money = [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))];
    return DiscardChangesScope(
      isDirty: _isDirty && !_saving,
      child: Scaffold(
        appBar: AppTopBar(title: _isEdit ? 'Edit product' : 'Add product'),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              Space.xl,
              Space.sm,
              Space.xl,
              Space.xxl,
            ),
            children: [
              AppTextField(
                label: 'Name',
                isRequired: true,
                controller: _name,
                hint: 'e.g. Hair Serum',
                textCapitalization: TextCapitalization.words,
                autofocus: !_isEdit,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Enter the product name.'
                    : null,
              ),
              Gap.h16,
              if (_isEdit)
                Container(
                  padding: const EdgeInsets.all(Space.md),
                  decoration: const BoxDecoration(
                    color: AppColors.chipSelected,
                    borderRadius: Radii.controlAll,
                  ),
                  child: Text(
                    'In stock: ${_p!.stockQty} ${_p.unit.name}. '
                    'Use "Adjust stock" on the product screen to change it.',
                    style: AppText.body.copyWith(color: AppColors.info),
                  ),
                )
              else
                AppTextField(
                  label: 'Opening stock',
                  isRequired: true,
                  controller: _stock,
                  keyboardType: TextInputType.number,
                  inputFormatters: digits,
                  hint: 'e.g. 10',
                  validator: (v) => _wholeNumber(v, 'the opening stock'),
                ),
              Gap.h12,
              const FieldLabel('Unit', required: true),
              Gap.h8,
              ChoiceChips<ProductUnit>(
                options: const [
                  ChoiceOption(ProductUnit.pcs, 'pcs'),
                  ChoiceOption(ProductUnit.ml, 'ml'),
                  ChoiceOption(ProductUnit.g, 'g'),
                ],
                selected: _unit,
                onSelected: (u) => setState(() => _unit = u),
              ),
              Gap.h16,
              AppTextField(
                label: 'Low-stock alert at',
                isRequired: true,
                controller: _alert,
                keyboardType: TextInputType.number,
                inputFormatters: digits,
                validator: (v) => _wholeNumber(v, 'the alert level'),
              ),
              Gap.h16,
              AppTextField(
                label: 'Selling price',
                controller: _price,
                prefixText: '₹ ',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: money,
                validator: _optionalMoney,
              ),
              Gap.h8,
              MoreDetails(
                initiallyOpen:
                    _p?.category != null || _p?.costPricePaise != null,
                children: [
                  AppTextField(
                    label: 'Category',
                    controller: _category,
                    hint: 'e.g. Hair care',
                    textCapitalization: TextCapitalization.words,
                  ),
                  AppTextField(
                    label: 'Cost price',
                    controller: _cost,
                    prefixText: '₹ ',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: money,
                    validator: _optionalMoney,
                  ),
                ],
              ),
              if (_isEdit) ...[
                Gap.h24,
                Center(
                  child: TextButton.icon(
                    onPressed: _toggleActive,
                    style: TextButton.styleFrom(
                      foregroundColor: _p!.isActive
                          ? AppColors.error
                          : AppColors.primary,
                    ),
                    icon: Icon(
                      _p.isActive
                          ? Icons.block_rounded
                          : Icons.check_circle_outline_rounded,
                    ),
                    label: Text(
                      _p.isActive ? 'Deactivate product' : 'Reactivate product',
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.xl,
              Space.sm,
              Space.xl,
              Space.lg,
            ),
            child: PrimaryButton(
              label: 'Save product',
              loading: _saving,
              onPressed: _save,
            ),
          ),
        ),
      ),
    );
  }
}
