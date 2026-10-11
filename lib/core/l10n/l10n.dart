import 'package:flutter/widgets.dart';

import '../../domain/errors.dart';
import '../../l10n/gen/app_localizations.dart';
import 'labels.dart';

export '../../l10n/gen/app_localizations.dart';
export 'labels.dart';

/// Short access to the current language's texts: `context.l10n.navMore`.
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// A rule-break from the business layer, in the current language.
  String errorText(DomainException e) => l10n.error(e.error);
}
