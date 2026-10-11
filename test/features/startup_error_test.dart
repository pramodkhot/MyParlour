import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myparlour/app/startup_error_app.dart';

void main() {
  testWidgets('start-up error explains and retries', (tester) async {
    var retries = 0;
    await tester.pumpWidget(
      StartupErrorApp(
        error: 'FileSystemException: No space left on device',
        onRetry: () async => retries++,
      ),
    );
    expect(find.text('MyParlour could not open its data'), findsOneWidget);
    expect(find.textContaining('No space left'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(retries, 1);
  });

  testWidgets('friendly error widget', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (_) => friendlyErrorWidget(
            FlutterErrorDetails(exception: Exception('boom')),
          ),
        ),
      ),
    );
    expect(find.textContaining('Something went wrong'), findsOneWidget);
  });
}
