import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myparlour/core/platform/contact_actions.dart';
import 'package:myparlour/core/widgets/round_action.dart';

import '../helpers/memory_store_file.dart';
import '../helpers/pump_app.dart';

class MockContactActions extends Mock implements ContactActions {}

void main() {
  late MockContactActions contacts;

  setUp(() {
    contacts = MockContactActions();
    when(() => contacts.call(any())).thenAnswer((_) async => true);
    when(() => contacts.whatsApp(any())).thenAnswer((_) async => false);
    when(() => contacts.sms(any())).thenAnswer((_) async => true);
    when(
      () => contacts.shareText(any(), subject: any(named: 'subject')),
    ).thenAnswer((_) async => true);
  });

  Future<void> start(WidgetTester tester, {MemoryStoreFile? storage}) async {
    usePhoneScreen(tester);
    await pumpDemoApp(
      tester,
      storage: storage,
      overrides: [contactActionsProvider.overrideWithValue(contacts)],
    );
    await enterApp(tester);
  }

  testWidgets('list shows active customers; search by name and phone', (
    tester,
  ) async {
    await start(tester);
    await openMoreSection(tester, 'Customers');

    expect(find.text('Priya Sharma'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'pri');
    await tester.pumpAndSettle();
    expect(find.text('Priya Sharma'), findsOneWidget);
    expect(find.text('Neha Verma'), findsNothing);

    await tester.enterText(find.byType(TextField).first, '91234');
    await tester.pumpAndSettle();
    expect(find.text('Neha Verma'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'nobody here');
    await tester.pumpAndSettle();
    expect(find.text('No customer matches your search.'), findsOneWidget);
  });

  testWidgets('add a customer, see the duplicate warning, survive restart', (
    tester,
  ) async {
    final storage = MemoryStoreFile();
    await start(tester, storage: storage);
    await tester.tap(find.text('Add customer'));
    await tester.pumpAndSettle();
    expect(find.text('Add customer'), findsWidgets);

    // Saving empty shows plain-language errors.
    await tester.tap(find.text('Save customer'));
    await tester.pumpAndSettle();
    expect(find.text('Enter the customer’s name.'), findsOneWidget);
    expect(find.text('Enter the mobile number.'), findsOneWidget);

    await typeInto(tester, 'Name', 'Zoya Khan');
    // Priya's number typed differently → warning, never blocking.
    await typeInto(tester, 'Mobile number', '09876543210');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.text('Already saved as Priya Sharma'), findsOneWidget);

    await typeInto(tester, 'Mobile number', '9900122334');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.text('Already saved as Priya Sharma'), findsNothing);

    await tester.tap(find.text('Save customer'));
    await tester.pumpAndSettle();
    expect(find.text('Customer saved'), findsOneWidget);

    // Restart the app from the saved data.
    await tester.pumpWidget(const SizedBox());
    await start(tester, storage: MemoryStoreFile(storage.text));
    await openMoreSection(tester, 'Customers');
    await tester.enterText(find.byType(TextField).first, 'zoya');
    await tester.pumpAndSettle();
    expect(find.text('Zoya Khan'), findsOneWidget);
    expect(find.text('99001 22334'), findsOneWidget);
  });

  testWidgets('leaving a half-filled form asks to discard', (tester) async {
    await start(tester);
    await openMoreSection(tester, 'Customers');
    await tester.tap(find.byTooltip('Add customer').first);
    await tester.pumpAndSettle();
    await typeInto(tester, 'Name', 'Half done');

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Discard changes?'), findsOneWidget);
    await tester.tap(find.text('Keep editing'));
    await tester.pumpAndSettle();
    expect(find.text('Half done'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();
    expect(find.text('Search name or phone'), findsOneWidget);
  });

  testWidgets('details: tabs, contact actions, edit, deactivate', (
    tester,
  ) async {
    await start(tester);
    await openMoreSection(tester, 'Customers');
    await tester.tap(find.text('Priya Sharma'));
    await tester.pumpAndSettle();

    // History shows her bills; Details shows figures; Notes has the seed note.
    expect(find.textContaining('BBP/'), findsWidgets);
    await tester.tap(find.text('Details'));
    await tester.pumpAndSettle();
    expect(find.text('Total spent'), findsOneWidget);
    await tester.tap(find.text('Notes'));
    await tester.pumpAndSettle();
    expect(find.text('Prefers less heat in smoothening.'), findsOneWidget);

    await tester.tap(find.text('Call'));
    await tester.pumpAndSettle();
    verify(() => contacts.call('98765 43210')).called(1);

    await tester.tap(find.text('WhatsApp'));
    await tester.pumpAndSettle();
    expect(
      find.text('No app on this phone can open WhatsApp links.'),
      findsOneWidget,
    );
    await clearMessages(tester);

    // Edit name.
    await tester.tap(find.byTooltip('Edit customer'));
    await tester.pumpAndSettle();
    await typeInto(tester, 'Name', 'Priya S. Sharma');
    await tester.tap(find.text('Save customer'));
    await tester.pumpAndSettle();
    await clearMessages(tester);
    expect(find.text('Priya S. Sharma'), findsOneWidget);

    // Deactivate from More.
    await tester.tap(find.widgetWithText(RoundAction, 'More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Deactivate customer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Deactivate'));
    await tester.pumpAndSettle();
    await clearMessages(tester);
    expect(find.text('Inactive'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Priya S. Sharma'), findsNothing);
    await tester.ensureVisible(find.textContaining('Inactive ('));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Inactive ('));
    await tester.pumpAndSettle();
    expect(find.text('Priya S. Sharma'), findsOneWidget);
  });
}
