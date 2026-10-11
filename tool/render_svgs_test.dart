// Renders the app's SVG artwork to PNG.
// Not part of the normal test run (it lives outside test/).
//
// Preview the illustrations (blush background):
//   flutter test tool/render_svgs_test.dart --plain-name preview --dart-define=OUT=<folder>
// Regenerate the iOS launch images (transparent leaf mark):
//   flutter test tool/render_svgs_test.dart --plain-name ios
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

const _out = String.fromEnvironment('OUT', defaultValue: 'build/svg_preview');
const _blush = Color(0xFFFFF6F7);
const _launchImages = 'ios/Runner/Assets.xcassets/LaunchImage.imageset';

void main() {
  group('preview', () {
    const files = {
      'leaf_mark': Size(192, 192),
      'welcome_woman': Size(720, 672),
      'salon_tools': Size(600, 160),
    };
    for (final entry in files.entries) {
      testWidgets(entry.key, (tester) async {
        await _render(
          tester,
          asset: entry.key,
          size: entry.value,
          background: _blush,
          path: '$_out/${entry.key}.png',
        );
      });
    }
  });

  // Launcher icons: the leaf mark on blush.
  //   flutter test tool/render_svgs_test.dart --plain-name icons
  group('icons', () {
    const android = {
      'mdpi': 48.0,
      'hdpi': 72.0,
      'xhdpi': 96.0,
      'xxhdpi': 144.0,
      'xxxhdpi': 192.0,
    };
    for (final entry in android.entries) {
      testWidgets('android ${entry.key}', (tester) async {
        await _renderIcon(
          tester,
          size: entry.value,
          rounded: true,
          path: 'android/app/src/main/res/mipmap-${entry.key}/ic_launcher.png',
        );
      });
    }

    // iOS sizes come from the file names, e.g. Icon-App-20x20@3x.png → 60.
    const iosDir = 'ios/Runner/Assets.xcassets/AppIcon.appiconset';
    final pattern = RegExp(r'Icon-App-([\d.]+)x[\d.]+@(\d)x\.png$');
    final iosFiles = Directory(iosDir)
        .listSync()
        .map((f) => f.path.replaceAll(r'\', '/'))
        .where(pattern.hasMatch)
        .toList();
    for (final path in iosFiles) {
      final m = pattern.firstMatch(path)!;
      final px = double.parse(m.group(1)!) * int.parse(m.group(2)!);
      testWidgets('ios ${path.split('/').last}', (tester) async {
        // iOS rounds the corners itself and needs an opaque square.
        await _renderIcon(tester, size: px, rounded: false, path: path);
      });
    }
  });

  group('ios', () {
    const scales = {
      'LaunchImage': 96.0,
      'LaunchImage@2x': 192.0,
      'LaunchImage@3x': 288.0,
    };
    for (final entry in scales.entries) {
      testWidgets(entry.key, (tester) async {
        await _render(
          tester,
          asset: 'leaf_mark',
          size: Size.square(entry.value),
          background: Colors.transparent,
          path: '$_launchImages/${entry.key}.png',
        );
      });
    }
  });
}

Future<void> _renderIcon(
  WidgetTester tester, {
  required double size,
  required bool rounded,
  required String path,
}) async {
  final key = GlobalKey();
  tester.view.physicalSize = Size.square(size);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  const loader = SvgAssetLoader('assets/illustrations/leaf_mark.svg');
  await tester.runAsync(
    () => svg.cache.putIfAbsent(
      loader.cacheKey(null),
      () => loader.loadBytes(null),
    ),
  );
  await tester.pumpWidget(
    RepaintBoundary(
      key: key,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _blush,
          border: rounded
              ? Border.all(color: const Color(0xFFF0E1E5), width: size / 96)
              : null,
          borderRadius: rounded ? BorderRadius.circular(size * 0.22) : null,
        ),
        child: SvgPicture(loader, width: size * 0.66, height: size * 0.66),
      ),
    ),
  );
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 100)),
  );
  await tester.pumpAndSettle();
  await tester.runAsync(() async {
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    await File(path).writeAsBytes(bytes!.buffer.asUint8List());
  });
}

Future<void> _render(
  WidgetTester tester, {
  required String asset,
  required Size size,
  required Color background,
  required String path,
}) async {
  final key = GlobalKey();
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final loader = SvgAssetLoader('assets/illustrations/$asset.svg');
  await tester.runAsync(
    () => svg.cache.putIfAbsent(
      loader.cacheKey(null),
      () => loader.loadBytes(null),
    ),
  );

  await tester.pumpWidget(
    RepaintBoundary(
      key: key,
      child: ColoredBox(
        color: background,
        child: SvgPicture(loader, width: size.width, height: size.height),
      ),
    ),
  );
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 200)),
  );
  await tester.pumpAndSettle();

  await tester.runAsync(() async {
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes!.buffer.asUint8List());
  });
}
