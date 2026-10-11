import 'package:flutter/material.dart';

import '../core/design/colors.dart';
import '../core/design/spacing.dart';
import '../core/design/typography.dart';
import '../core/l10n/app_language.dart';
import '../core/l10n/l10n.dart';
import '../core/l10n/language_controller.dart';
import '../core/widgets/buttons.dart';
import 'theme.dart';

/// Shown instead of the app when its data could not be opened at start-up
/// (for example, the phone's storage is full).
class StartupErrorApp extends StatefulWidget {
  const StartupErrorApp({
    super.key,
    required this.error,
    required this.onRetry,
    this.language,
  });

  final Object error;

  /// The saved language, when it could be read; otherwise the phone's
  /// language is used if the app supports it.
  final AppLanguage? language;

  /// Tries to start the app again.
  final Future<void> Function() onRetry;

  @override
  State<StartupErrorApp> createState() => _StartupErrorAppState();
}

class _StartupErrorAppState extends State<StartupErrorApp> {
  bool _retrying = false;

  Future<void> _retry() async {
    setState(() => _retrying = true);
    await widget.onRetry();
    if (mounted) setState(() => _retrying = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appName,
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      locale: widget.language?.locale,
      supportedLocales: [for (final l in AppLanguage.values) l.locale],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Builder(
        builder: (context) => Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(Space.xxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: const BoxDecoration(
                      color: AppColors.errorBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.sd_card_alert_outlined,
                      color: AppColors.error,
                      size: 40,
                    ),
                  ),
                  Gap.h20,
                  Text(
                    context.l10n.startupErrorTitle,
                    textAlign: TextAlign.center,
                    style: AppText.screenTitle,
                  ),
                  Gap.h12,
                  Text(
                    context.l10n.startupErrorMessage,
                    textAlign: TextAlign.center,
                    style: AppText.body.copyWith(color: AppColors.textMuted),
                  ),
                  Gap.h8,
                  Text(
                    '${widget.error}',
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption,
                  ),
                  Gap.h24,
                  PrimaryButton(
                    label: context.l10n.commonTryAgain,
                    loading: _retrying,
                    onPressed: _retry,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// In release builds, a screen that hits an unexpected error shows this
/// instead of Flutter's grey error box.
Widget friendlyErrorWidget(FlutterErrorDetails details) {
  return Material(
    color: AppColors.blush,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.xl),
        child: Builder(
          builder: (context) {
            // Safe lookup: the error may come from a tree without the
            // app's texts; fall back to English then.
            final l10n =
                Localizations.of<AppLocalizations>(context, AppLocalizations) ??
                lookupAppLocalizations(const Locale('en'));
            return Text(
              l10n.startupScreenError,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
            );
          },
        ),
      ),
    ),
  );
}
