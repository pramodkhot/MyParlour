import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/design/colors.dart';
import '../../../core/design/spacing.dart';
import '../../../core/design/typography.dart';

/// Four shortcut tiles. The first is filled burgundy.
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      (Icons.add_rounded, 'New appointment', Routes.newAppointment(), true),
      (
        Icons.person_add_alt_outlined,
        'Add customer',
        Routes.newCustomer,
        false,
      ),
      (Icons.receipt_long_outlined, 'Create bill', Routes.newBill(), false),
      (
        Icons.account_balance_wallet_outlined,
        'Add expense',
        Routes.newExpense,
        false,
      ),
    ];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (icon, label, path, filled) in actions)
          Expanded(
            child: _Tile(
              icon: icon,
              label: label,
              filled: filled,
              onTap: () => context.go(path),
            ),
          ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: Radii.controlAll,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Space.xs),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: filled ? AppColors.primary : AppColors.surface,
                  borderRadius: Radii.controlAll,
                  border: filled ? null : Border.all(color: AppColors.border),
                  boxShadow: const [AppColors.cardShadow],
                ),
                child: Icon(
                  icon,
                  color: filled ? Colors.white : AppColors.primary,
                  size: 24,
                ),
              ),
              Gap.h8,
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppText.caption.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
