import 'package:flutter/material.dart';

import '../../../core/design/colors.dart';
import '../../../core/design/spacing.dart';
import '../../../core/design/typography.dart';
import '../../../core/format/dates.dart';
import '../../../core/format/money.dart';
import '../../../core/widgets/search_field.dart';
import '../../../domain/models/invoice.dart';
import '../../../domain/models/product.dart';
import '../../../domain/models/service_item.dart';
import '../../../domain/repositories/repositories.dart';

/// "+ Add service or product": a searchable sheet with Services and
/// Products tabs. Resolves to the line to add, or null.
Future<BillLine?> showItemPicker(
  BuildContext context, {
  required List<ServiceItem> services,
  required List<Product> products,
  required int defaultTaxRateBp,
  String? staffId,
}) {
  return showModalBottomSheet<BillLine>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (context) => FractionallySizedBox(
      heightFactor: 0.9,
      child: _Picker(
        services: services,
        products: products,
        defaultTaxRateBp: defaultTaxRateBp,
        staffId: staffId,
      ),
    ),
  );
}

class _Picker extends StatefulWidget {
  const _Picker({
    required this.services,
    required this.products,
    required this.defaultTaxRateBp,
    this.staffId,
  });

  final List<ServiceItem> services;
  final List<Product> products;
  final int defaultTaxRateBp;
  final String? staffId;

  @override
  State<_Picker> createState() => _PickerState();
}

class _PickerState extends State<_Picker> {
  String _query = '';

  bool _matches(String name, String? category) {
    final q = _query.trim().toLowerCase();
    return q.isEmpty ||
        name.toLowerCase().contains(q) ||
        (category?.toLowerCase().contains(q) ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final services = widget.services
        .where((s) => _matches(s.name, s.category))
        .toList();
    final products = widget.products
        .where((p) => _matches(p.name, p.category))
        .toList();
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.sm),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Add to bill', style: AppText.barTitle),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.xl),
            child: SearchField(
              hint: 'Search services or products',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          const TabBar(
            tabs: [
              Tab(text: 'Services'),
              Tab(text: 'Products'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                ListView(
                  children: [
                    for (final s in services)
                      ListTile(
                        title: Text(s.name),
                        subtitle: Text(
                          '${s.category} · ${Dates.duration(s.durationMin)}',
                        ),
                        trailing: Text(
                          Money.format(s.pricePaise),
                          style: AppText.bodyStrong,
                        ),
                        onTap: () => Navigator.of(context).pop(
                          BillLine(
                            type: InvoiceItemType.service,
                            refId: s.id,
                            name: s.name,
                            unitPricePaise: s.pricePaise,
                            qty: 1,
                            taxRateBp: s.taxRateBp,
                            staffId: widget.staffId,
                          ),
                        ),
                      ),
                    if (services.isEmpty) const _NoMatch(),
                  ],
                ),
                ListView(
                  children: [
                    for (final p in products) _productTile(context, p),
                    if (products.isEmpty) const _NoMatch(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _productTile(BuildContext context, Product p) {
    final price = p.sellingPricePaise;
    final out = p.stockQty <= 0;
    final enabled = !out && price != null;
    return ListTile(
      enabled: enabled,
      title: Text(p.name),
      subtitle: Text(
        out
            ? 'Out of stock'
            : price == null
            ? 'No selling price set'
            : 'In stock: ${p.stockQty}',
        style: out ? const TextStyle(color: AppColors.error) : null,
      ),
      trailing: price == null
          ? null
          : Text(Money.format(price), style: AppText.bodyStrong),
      onTap: enabled
          ? () => Navigator.of(context).pop(
              BillLine(
                type: InvoiceItemType.product,
                refId: p.id,
                name: p.name,
                unitPricePaise: price,
                qty: 1,
                taxRateBp: widget.defaultTaxRateBp,
              ),
            )
          : null,
    );
  }
}

class _NoMatch extends StatelessWidget {
  const _NoMatch();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Space.xl),
      child: Text(
        'Nothing matches your search.',
        textAlign: TextAlign.center,
        style: AppText.body.copyWith(color: AppColors.textMuted),
      ),
    );
  }
}
