import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/design/colors.dart';
import '../core/design/spacing.dart';
import '../core/design/typography.dart';

/// The app-wide Material theme built from the design tokens.
ThemeData buildAppTheme() {
  final scheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.chipSelected,
        onPrimaryContainer: AppColors.info,
        secondary: AppColors.rose,
        onSecondary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.text,
        onSurfaceVariant: AppColors.textMuted,
        error: AppColors.error,
        onError: Colors.white,
        outline: AppColors.border,
        outlineVariant: AppColors.divider,
        surfaceTint: Colors.transparent,
      );

  const inputBorder = OutlineInputBorder(
    borderRadius: Radii.controlAll,
    borderSide: BorderSide(color: AppColors.border),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: AppText.sans,
    fontFamilyFallback: AppText.sansFallback,
    scaffoldBackgroundColor: AppColors.blush,
    canvasColor: AppColors.blush,
    dividerColor: AppColors.divider,
    splashFactory: InkSparkle.splashFactory,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    textTheme: const TextTheme(
      headlineMedium: AppText.screenTitle,
      titleLarge: AppText.barTitle,
      titleMedium: AppText.sectionTitle,
      bodyLarge: AppText.body,
      bodyMedium: AppText.body,
      bodySmall: AppText.caption,
      labelLarge: AppText.button,
      labelMedium: AppText.label,
      labelSmall: AppText.caption,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.blush,
      foregroundColor: AppColors.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: AppText.barTitle,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: Radii.cardAll,
        side: BorderSide(color: AppColors.border),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Space.lg,
        vertical: 15,
      ),
      hintStyle: AppText.body.copyWith(color: AppColors.textMuted),
      prefixIconColor: AppColors.textMuted,
      border: inputBorder,
      enabledBorder: inputBorder,
      focusedBorder: inputBorder.copyWith(
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: inputBorder.copyWith(
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: inputBorder.copyWith(
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      errorStyle: AppText.caption.copyWith(color: AppColors.error),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.45),
        disabledForegroundColor: Colors.white,
        minimumSize: const Size.fromHeight(54),
        shape: const RoundedRectangleBorder(borderRadius: Radii.controlAll),
        textStyle: AppText.button,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.primary,
        minimumSize: const Size.fromHeight(54),
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        shape: const RoundedRectangleBorder(borderRadius: Radii.controlAll),
        textStyle: AppText.button,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size(Space.tapTarget, Space.tapTarget),
        textStyle: AppText.link,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.text,
        minimumSize: const Size(Space.tapTarget, Space.tapTarget),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 3,
      shape: CircleBorder(),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      height: 68,
      indicatorColor: AppColors.chipSelected,
      indicatorShape: const StadiumBorder(),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          size: 24,
          color: states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.textMuted,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => AppText.caption.copyWith(
          fontWeight: FontWeight.w700,
          color: states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.textMuted,
        ),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: AppColors.border,
      shape: RoundedRectangleBorder(borderRadius: Radii.sheetTop),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: Radii.cardAll),
      titleTextStyle: AppText.barTitle,
      contentTextStyle: AppText.body,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.text,
      contentTextStyle: AppText.body.copyWith(color: Colors.white),
      shape: const RoundedRectangleBorder(borderRadius: Radii.controlAll),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.textMuted,
      indicatorColor: AppColors.primary,
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: AppColors.divider,
      labelStyle: AppText.label.copyWith(fontWeight: FontWeight.w700),
      unselectedLabelStyle: AppText.label,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.primary
            : Colors.transparent,
      ),
      side: const BorderSide(color: AppColors.textMuted, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? Colors.white
            : AppColors.textMuted,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.primary
            : AppColors.divider,
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.primary,
      textColor: AppColors.text,
      minVerticalPadding: Space.md,
    ),
  );
}
