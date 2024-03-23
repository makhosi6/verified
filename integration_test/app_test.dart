import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:verified/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-To-End Test >> ', () async {
    testWidgets('Check of app can boot successfully', (tester) async {
      // Load app widget.
      await tester.pumpWidget(const RootAppWithBloc());

      // wait for
      await Future.delayed(const Duration(seconds: 10));

      // Finds the floating action button to tap on.
      final fab = find.byKey(const Key('main-search-fab'));

      // Emulate a tap on the floating action button.
      await tester.tap(fab);

      // Trigger a frame.
      await tester.pumpAndSettle();

      // Verify
      expect(find.text('Verification'), findsOneWidget);
    });
  });
}
