import 'package:flutter/material.dart';

import '../../../core/design/spacing.dart';
import '../../../core/design/typography.dart';
import '../../../core/format/dates.dart';
import '../../../core/format/money.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/search_field.dart';
import '../../../domain/models/service_item.dart';

/// Searchable tick list of services. Resolves to the chosen service ids
/// (in menu order), or null if closed without confirming.
Future<Set<String>?> showServicePicker(
  BuildContext context, {
  required List<ServiceItem> services,
  required Set<String> selected,
}) {
  return showModalBottomSheet<Set<String>>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (context) => FractionallySizedBox(
      heightFactor: 0.9,
      child: _ServiceList(services: services, initial: selected),
    ),
  );
}

class _ServiceList extends StatefulWidget {
  const _ServiceList({required this.services, required this.initial});

  final List<ServiceItem> services;
  final Set<String> initial;

  @override
  State<_ServiceList> createState() => _ServiceListState();
}

class _ServiceListState extends State<_ServiceList> {
  late final Set<String> _selected = {...widget.initial};
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final shown = widget.services
        .where(
          (s) =>
              q.isEmpty ||
              s.name.toLowerCase().contains(q) ||
              s.category.toLowerCase().contains(q),
        )
        .toList();
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.sm),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Choose services', style: AppText.barTitle),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.xl),
          child: SearchField(
            hint: 'Search services',
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              for (final s in shown)
                CheckboxListTile(
                  value: _selected.contains(s.id),
                  onChanged: (v) => setState(() {
                    if (v ?? false) {
                      _selected.add(s.id);
                    } else {
                      _selected.remove(s.id);
                    }
                  }),
                  title: Text(s.name),
                  subtitle: Text(
                    '${s.category} · ${Dates.duration(s.durationMin)}',
                  ),
                  secondary: Text(
                    Money.format(s.pricePaise),
                    style: AppText.bodyStrong,
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.xl,
              Space.sm,
              Space.xl,
              Space.lg,
            ),
            child: PrimaryButton(
              label: _selected.isEmpty
                  ? 'Done'
                  : 'Add ${_selected.length} service'
                        '${_selected.length == 1 ? '' : 's'}',
              onPressed: () => Navigator.of(context).pop(_selected),
            ),
          ),
        ),
      ],
    );
  }
}
