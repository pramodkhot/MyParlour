// Captures phone-sized screenshots of key screens with the real fonts,
// for a visual check. Not part of the normal test run.
//
//   flutter test tool/screenshots_test.dart --dart-define=OUT=<folder>
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test/helpers/pump_app.dart';

const _out = String.fromEnvironment('OUT', defaultValue: 'build/screenshots');

Future<void> _loadFonts() async {
  Future<void> family(String name, List<String> files) async {
    final loader = FontLoader(name);
    for (final f in files) {
      loader.addFont(
        File(f).readAsBytes().then((b) => ByteData.view(b.buffer)),
      );
    }
    await loader.load();
  }

  await family('Manrope', [
    for (final w in [400, 500, 600, 700, 800]) 'assets/fonts/Manrope-$w.ttf',
  ]);
  await family('PlayfairDisplay', [
    for (final w in [400, 600, 700]) 'assets/fonts/PlayfairDisplay-$w.ttf',
  ]);
  final flutterRoot =
      Platform.environment['FLUTTER_ROOT'] ??
      File(
        Platform.resolvedExecutable,
      ).parent.parent.parent.parent.parent.parent.path;
  await family('MaterialIcons', [
    '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  ]);
}

Future<void> _shot(WidgetTester tester, String name) async {
  await tester.runAsync(() async {
    final view = tester.binding.renderViews.first;
    final layer = view.debugLayer! as OffsetLayer;
    final image = await layer.toImage(Offset.zero & view.size);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('$_out/$name.png');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes!.buffer.asUint8List());
  });
}

void main() {
  setUpAll(_loadFonts);

  testWidgets('welcome and dashboard', (tester) async {
    usePhoneScreen(tester);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(412, 915);
    await pumpDemoApp(tester);
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 300)),
    );
    await tester.pumpAndSettle();
    await _shot(tester, '01_welcome');

    await enterApp(tester);
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();
    await _shot(tester, '02_dashboard_top');

    await tester.drag(find.byType(Scrollable).first, const Offset(0, -600));
    await tester.pumpAndSettle();
    await _shot(tester, '03_dashboard_bottom');

    await tester.drag(find.byType(Scrollable).first, const Offset(0, 1000));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Alerts (new)'));
    await tester.pumpAndSettle();
    await _shot(tester, '04_alerts');
  });

  Future<void> open(WidgetTester tester, String section) async {
    usePhoneScreen(tester);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(412, 915);
    await pumpDemoApp(tester);
    await enterApp(tester);
    await openMoreSection(tester, section);
  }

  Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 5),
    );
  }

  testWidgets('customers', (tester) async {
    await open(tester, 'Customers');
    await _shot(tester, '10_customers');
    await tapAndSettle(tester, find.text('Priya Sharma'));
    await _shot(tester, '11_customer_history');
    await tapAndSettle(tester, find.text('Details'));
    await _shot(tester, '12_customer_details');
  });

  testWidgets('customer form', (tester) async {
    await open(tester, 'Customers');
    await tapAndSettle(tester, find.byTooltip('Add customer').first);
    await typeInto(tester, 'Mobile number', '9876543210');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
    await _shot(tester, '13_customer_form');
  });

  testWidgets('services', (tester) async {
    await open(tester, 'Services');
    await _shot(tester, '20_services');
    await tapAndSettle(tester, find.text('Hair Spa'));
    await _shot(tester, '21_service_form');
  });

  testWidgets('appointments', (tester) async {
    usePhoneScreen(tester);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(412, 915);
    await pumpDemoApp(tester);
    await enterApp(tester);
    await tapAndSettle(tester, navItem('Appointments'));
    await _shot(tester, '40_appointments');
    await tapAndSettle(tester, find.text('Sneha Patil'));
    await _shot(tester, '41_appointment_detail');
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tapAndSettle(tester, find.byTooltip('Book appointment'));
    await tapAndSettle(tester, find.text('Search name or phone'));
    await tapAndSettle(tester, find.text('Kavya Nair'));
    await tapAndSettle(tester, find.text('Add services'));
    await tapAndSettle(tester, find.text('Haircut'));
    await tapAndSettle(tester, find.text('Hair Spa'));
    await tapAndSettle(tester, find.text('Add 2 services'));
    await _shot(tester, '42_booking_top');
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
    await tester.pumpAndSettle();
    await _shot(tester, '43_booking_bottom');
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 300));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Anita'));
    await tapAndSettle(tester, find.text('Anita'));
    await tapAndSettle(tester, find.text('Book appointment'));
    await _shot(tester, '44_overlap');
  });

  testWidgets('staff', (tester) async {
    await open(tester, 'Staff');
    await _shot(tester, '30_staff');
    await tapAndSettle(tester, find.text('Anita'));
    await _shot(tester, '31_staff_detail');
    await tapAndSettle(tester, find.byTooltip('Edit staff'));
    await _shot(tester, '32_staff_form');
  });
}
