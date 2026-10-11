import 'package:flutter/material.dart';

import '../core/design/colors.dart';
import '../core/design/spacing.dart';
import '../core/design/typography.dart';
import '../core/widgets/buttons.dart';
import 'theme.dart';

/// Shown instead of the app when its data could not be opened at start-up
/// (for example, the phone's storage is full).
class StartupErrorApp extends StatefulWidget {
  const StartupErrorApp({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final Object error;

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
      title: 'MyParlour',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: Scaffold(
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
                const Text(
                  'MyParlour could not open its data',
                  textAlign: TextAlign.center,
                  style: AppText.screenTitle,
                ),
                Gap.h12,
                Text(
                  'Please check that the phone has free storage space, then '
                  'try again.',
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
                  label: 'Try again',
                  loading: _retrying,
                  onPressed: _retry,
                ),
              ],
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
  return const Material(
    color: AppColors.blush,
    child: Center(
      child: Padding(
        padding: EdgeInsets.all(Space.xl),
        child: Text(
          'Something went wrong on this screen. Please go back and try again.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
      ),
    ),
  );
}
