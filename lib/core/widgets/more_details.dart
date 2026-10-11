import 'package:flutter/material.dart';

import '../design/spacing.dart';
import '../l10n/l10n.dart';

/// "+ More details" link that reveals extra optional fields.
class MoreDetails extends StatefulWidget {
  const MoreDetails({
    super.key,
    required this.children,
    this.initiallyOpen = false,
  });

  final List<Widget> children;

  /// Open from the start, e.g. when editing a record that already has
  /// values in these fields.
  final bool initiallyOpen;

  @override
  State<MoreDetails> createState() => _MoreDetailsState();
}

class _MoreDetailsState extends State<MoreDetails> {
  late bool _open = widget.initiallyOpen;

  @override
  Widget build(BuildContext context) {
    if (!_open) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => setState(() => _open = true),
          icon: const Icon(Icons.add_rounded, size: 20),
          label: Text(context.l10n.commonMoreDetails),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < widget.children.length; i++) ...[
          if (i > 0) Gap.h16,
          widget.children[i],
        ],
      ],
    );
  }
}
