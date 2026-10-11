import 'package:flutter/material.dart';

import '../../../core/design/colors.dart';
import '../../../core/design/spacing.dart';
import '../../../core/design/typography.dart';
import '../../../core/format/phone.dart';
import '../../../core/widgets/avatar_initials.dart';
import '../../../core/widgets/search_field.dart';
import '../../../domain/models/customer.dart';
import '../../customers/customer_form_screen.dart';

/// Opens a searchable list of customers with a "+ New" button. Resolves
/// to the chosen (or newly added) customer, or null.
Future<Customer?> showCustomerPicker(
  BuildContext context, {
  required List<Customer> customers,
}) {
  return showModalBottomSheet<Customer>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (context) => FractionallySizedBox(
      heightFactor: 0.9,
      child: _CustomerList(customers: customers),
    ),
  );
}

/// Opens the Add customer form (S8) as a sheet. Resolves to the saved
/// customer, or null.
Future<Customer?> showNewCustomerSheet(BuildContext context) {
  return showModalBottomSheet<Customer>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    showDragHandle: false,
    builder: (context) => const FractionallySizedBox(
      heightFactor: 0.95,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        child: CustomerForm(asSheet: true),
      ),
    ),
  );
}

class _CustomerList extends StatefulWidget {
  const _CustomerList({required this.customers});

  final List<Customer> customers;

  @override
  State<_CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<_CustomerList> {
  String _query = '';

  List<Customer> get _matches {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.customers;
    final digits = PhoneNumber.searchDigits(q);
    return widget.customers.where((c) {
      if (c.name.toLowerCase().contains(q)) return true;
      if (digits.isEmpty) return false;
      return (PhoneNumber.normalise(c.phone) ?? c.phone).contains(digits);
    }).toList();
  }

  Future<void> _addNew() async {
    final navigator = Navigator.of(context);
    final created = await showNewCustomerSheet(context);
    if (created != null && navigator.mounted) navigator.pop(created);
  }

  @override
  Widget build(BuildContext context) {
    final matches = _matches;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.md, Space.sm),
          child: Row(
            children: [
              const Expanded(
                child: Text('Choose customer', style: AppText.barTitle),
              ),
              TextButton.icon(
                onPressed: _addNew,
                icon: const Icon(Icons.add_rounded),
                label: const Text('New'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.xl),
          child: SearchField(
            hint: 'Search name or phone',
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Gap.h8,
        Expanded(
          child: matches.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(Space.xl),
                  child: Column(
                    children: [
                      Text(
                        'No customer matches your search.',
                        style: AppText.body.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      Gap.h8,
                      TextButton.icon(
                        onPressed: _addNew,
                        icon: const Icon(Icons.person_add_alt_outlined),
                        label: const Text('Add new customer'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: matches.length,
                  itemBuilder: (context, i) => ListTile(
                    leading: AvatarInitials(name: matches[i].name, size: 40),
                    title: Text(matches[i].name),
                    subtitle: Text(PhoneNumber.display(matches[i].phone)),
                    onTap: () => Navigator.of(context).pop(matches[i]),
                  ),
                ),
        ),
      ],
    );
  }
}
