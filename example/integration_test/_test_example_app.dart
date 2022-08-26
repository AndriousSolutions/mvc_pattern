// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';

import 'package:example/src/controller.dart' show Controller;

import 'package:example/src/view.dart';

const _location = '========================== test_example_app.dart';

Future<void> integrationTesting(WidgetTester tester) async {
  //
  const count = 9;

  // Verify that our counter starts at 0.
  expect(find.text('0'), findsOneWidget, reason: _location);

  /// Increment the counter
  for (int cnt = 0; cnt <= count - 1; cnt++) {
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byKey(const Key('+')));
    await tester.pumpAndSettle();
  }

  // Successfully incremented.
  expect(find.text('0'), findsNothing, reason: _location);

  expect(find.text(count.toString()), findsOneWidget, reason: _location);

  await tester.tap(find.byKey(const Key('Page 2')));
  await tester.pumpAndSettle();

  /// Increment the counter
  for (int cnt = 0; cnt <= count - 1; cnt++) {
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byKey(const Key('+')));
    await tester.pumpAndSettle();
  }

  /// Increment the counter
  for (int cnt = 0; cnt <= count - 1; cnt++) {
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byKey(const Key('Page 1 Counter')));
    await tester.pumpAndSettle();
  }

  /// Go to Page 1
  await tester.tap(find.byKey(const Key('Page 1')));
  await tester.pumpAndSettle();

  expect(find.text((count * 2).toString()), findsOneWidget, reason: _location);

  /// Go to Page 2
  await tester.tap(find.byKey(const Key('Page 2')));
  await tester.pumpAndSettle();

  /// Go to Page 3
  await tester.tap(find.byKey(const Key('Page 3')));
  await tester.pumpAndSettle();

  /// Increment the counter
  for (int cnt = 0; cnt <= count - 1; cnt++) {
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byKey(const Key('+')));
    await tester.pumpAndSettle();
  }

  expect(find.text((count).toString()), findsOneWidget, reason: _location);

  await tester.tap(find.byKey(const Key('Page 1')));
  await tester.pumpAndSettle();

  /// Test 'Hello! example' app
  await testHomePageApp(tester);

  /// Return to Page 1
  await tester.tap(find.byKey(const Key('Page 1')));
  await tester.pumpAndSettle();

  await testInheritedWidgetApp(tester);

  /// Return to Page 1
  await tester.tap(find.byKey(const Key('Page 1')));
  await tester.pumpAndSettle();

  await testPage2State(tester);

  /// Return to Page 1
  await tester.tap(find.byKey(const Key('Page 1')));
  await tester.pumpAndSettle();
}

Future<void> testHomePageApp(WidgetTester tester) async {
  /// Go to Page 2
  await tester.tap(find.byKey(const Key('Page 2')));
  await tester.pumpAndSettle();

  /// Go to Page 3
  await tester.tap(find.byKey(const Key('Page 3')));
  await tester.pumpAndSettle();

  // Again, this tap doesn't seem to work, and so I go to the Navigator.
  await tester.tap(find.byKey(const Key('Hello! example')));
  await tester.pumpAndSettle();

  expect(find.text('Hello!'), findsOneWidget);

  const count = 5;

  /// Increment the counter
  for (int cnt = 0; cnt <= count - 1; cnt++) {
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byKey(const Key('+')));
    await tester.pumpAndSettle();
  }

  expect(find.text('Hello There!'), findsOneWidget);

  /// Increment the counter
  for (int cnt = 0; cnt <= count - 1; cnt++) {
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byKey(const Key('+')));
    await tester.pumpAndSettle();
  }

  expect(find.text('How are you?'), findsOneWidget);

  /// Increment the counter
  for (int cnt = 0; cnt <= count - 1; cnt++) {
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byKey(const Key('+')));
    await tester.pumpAndSettle();
  }

  expect(find.text('Are you good?'), findsOneWidget);

  /// Retreat back one screen
  await tester.tap(find.byTooltip('Back'));
  await tester.pumpAndSettle();
}

Future<void> testInheritedWidgetApp(WidgetTester tester) async {
  /// Go to Page 2
  await tester.tap(find.byKey(const Key('Page 2')));
  await tester.pumpAndSettle();

  /// Go to Page 3
  await tester.tap(find.byKey(const Key('Page 3')));
  await tester.pumpAndSettle();

  // Again, this tap doesn't seem to work, and so I go to the Navigator.
  await tester.tap(find.byKey(const Key('InheritedWidget example')));
  await tester.pumpAndSettle();

  expect(find.text('New Dogs'), findsOneWidget);

  /// Retreat back one screen
  await tester.tap(find.byTooltip('Back'));
  await tester.pumpAndSettle();
}

Future<void> testPage2State(WidgetTester tester) async {
  /// Go to Page 2
  await tester.tap(find.byKey(const Key('Page 2')));
  await tester.pumpAndSettle();

  /// Go to Page 3
  await tester.tap(find.byKey(const Key('Page 3')));
  await tester.pumpAndSettle();

  /// Start with the first State object.
  // Find its StatefulWidget first then the 'type' of State object.
  final appState = tester.firstState<AppStateMVC>(find.byType(MyApp));

  expect(appState, isA<AppStateMVC>(), reason: _location);

  /// Retrieve one of its Controllers by type.
  final con = appState.controllerByType<Controller>()!;

  /// Of course, you can retrieve the State object its collected.
  StateMVC statePage2 = con.stateOf<Page2>()!;

  statePage2.buildInherited();

  /// In harmony with Flutter's own API
  (statePage2 as InheritedStateMVC).notifyClients();

  statePage2.refresh();

  final child = statePage2.inheritedStatefulWidget;

  expect(child, isA<Widget>(), reason: _location);

  final widget = child.inheritedChildWidget;

  expect(widget, isA<Widget>(), reason: _location);
}

Future<void> resetPage1Count(WidgetTester tester) async {
  //
  await tester.tap(find.byKey(const Key('Page 2')));
  await tester.pumpAndSettle();
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('Page 3')));
  await tester.pumpAndSettle();

  // Tapping doesn't seem to work, and so I'll grab the State object itself.
  await tester.tap(find.byKey(const Key('New Key')));
  await tester.pumpAndSettle();

  // Find its StatefulWidget first then the 'type' of State object.
  AppStateMVC rootState = tester.firstState<AppStateMVC>(find.byType(MyApp));
  rootState.setState(() {});
  await tester.pumpAndSettle();

  /// It goes to Page 1 automatically.
  // await tester.tap(find.byKey(const Key('Page 1')));
  // await tester.pumpAndSettle();

  expect(find.text('0'), findsOneWidget, reason: _location);
}
