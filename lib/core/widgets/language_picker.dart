import 'package:flutter/material.dart';

import '../l10n/app_language.dart';
import '../l10n/l10n.dart';

/// English | मराठी | हिन्दी — each name in its own script so anyone can
/// find theirs whatever language is showing.
class LanguagePicker extends StatelessWidget {
  const LanguagePicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final AppLanguage selected;
  final ValueChanged<AppLanguage> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.languageTitle,
      container: true,
      child: SizedBox(
        width: double.infinity,
        child: SegmentedButton<AppLanguage>(
          showSelectedIcon: false,
          segments: [
            for (final language in AppLanguage.values)
              ButtonSegment(
                value: language,
                label: Text(
                  language.nativeName,
                  key: Key('language.${language.name}'),
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
          ],
          selected: {selected},
          onSelectionChanged: (s) => onChanged(s.first),
        ),
      ),
    );
  }
}
