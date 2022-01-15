// Copyright 2018 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The 'show' clause is not essential. Merely for your reference.

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

import '_test_controller.dart';

import '_test_statemvc.dart';

import '_test_example_app.dart';

void main() => testApp(MyApp(key: UniqueKey()));

void testApp(MyApp app) {
  //
  testWidgets('test mvc_pattern', (WidgetTester tester) async {
    // Tells the tester to build a UI based on the widget tree passed to it
    await tester.pumpWidget(app);

    /// Flutter won’t automatically rebuild your widget in the test environment.
    /// Use pump() or pumpAndSettle() to ask Flutter to rebuild the widget.

    /// pumpAndSettle() waits for all animations to complete.
    await tester.pumpAndSettle();

    /// Explicitly provide what's intentionally should be accessible
    /// but is made accessible for 'internal testing' of this framework.
    StateMVC stateObj = app.appState;

    /// Tests StateMVC object again!
    await testsStateMVC(stateObj);

    /// Tests Controller object
    testsController(stateObj);

    /// Test the example app accompanying the package
    await testExampleApp(tester);
  });
}
