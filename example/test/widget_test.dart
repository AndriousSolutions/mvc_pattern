// Copyright 2018 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The 'show' clause is not essential. Merely for your reference.

import 'package:example/src/view.dart' show MyApp, UniqueKey;

import '../integration_test/_test_example_app.dart' show integrationTesting;

import '_unit_testing.dart' show unitTesting;

import 'package:flutter_test/flutter_test.dart';

import 'package:integration_test/integration_test.dart';

void main() => testMyApp();

/// Also called in package's own testing file, test/widget_test.dart
void testMyApp() {
  //
  final app = MyApp(key: UniqueKey());

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('test mvc_pattern', (WidgetTester tester) async {
    // Tells the tester to build a UI based on the widget tree passed to it
    await tester.pumpWidget(app);

    /// Flutter won’t automatically rebuild your widget in the test environment.
    /// Use pump() or pumpAndSettle() to ask Flutter to rebuild the widget.

    /// pumpAndSettle() waits for all animations to complete.
    await tester.pumpAndSettle();

    /// Preform integration first to set up
    /// WidgetsBinding.instance is IntegrationTestWidgetsFlutterBinding
    await integrationTesting(tester);

    await unitTesting(tester);
  });
}
