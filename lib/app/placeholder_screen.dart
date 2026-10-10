import 'package:flutter/material.dart';

import '../core/widgets/app_top_bar.dart';
import '../core/widgets/empty_state.dart';

/// Temporary screen for sections that are built in a later phase.
/// Each use is replaced by the real screen in its phase.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.phase,
  });

  final String title;
  final IconData icon;
  final int phase;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: title),
      body: Center(
        child: SingleChildScrollView(
          child: EmptyState(
            icon: icon,
            message: '$title will be ready in build phase $phase.',
          ),
        ),
      ),
    );
  }
}
