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
