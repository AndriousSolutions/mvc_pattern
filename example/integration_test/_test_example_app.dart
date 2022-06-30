// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';

import 'package:example/src/view.dart';

const location = '========================== test_example_app.dart';

Future<void> integrationTesting(WidgetTester tester) async {
  //
  const count = 9;

  // Verify that our counter starts at 0.
  expect(find.text('0'), findsOneWidget, reason: location);

  /// Increment the counter
  for (int cnt = 0; cnt <= count - 1; cnt++) {
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byKey(const Key('+')));
    await tester.pumpAndSettle();
  }

  // Successfully incremented.
  expect(find.text('0'), findsNothing, reason: location);

  expect(find.text(count.toString()), findsOneWidget, reason: location);

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

  /// Got to Page 1
  await tester.tap(find.byKey(const Key('Page 1')));
  await tester.pumpAndSettle();

  expect(find.text((count * 2).toString()), findsOneWidget, reason: location);

  /// Got to Page 2
  await tester.tap(find.byKey(const Key('Page 2')));
  await tester.pumpAndSettle();

  /// Got to Page 3
  await tester.tap(find.byKey(const Key('Page 3')));
  await tester.pumpAndSettle();

  /// Increment the counter
  for (int cnt = 0; cnt <= count - 1; cnt++) {
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byKey(const Key('+')));
    await tester.pumpAndSettle();
  }

  expect(find.text((count).toString()), findsOneWidget, reason: location);

  await tester.tap(find.byKey(const Key('Page 1')));
  await tester.pumpAndSettle();

  await testHomePageApp(tester);

  /// Return to Page 1
  await tester.tap(find.byKey(const Key('Page 1')));
  await tester.pumpAndSettle();

  await testInheritedWidgetApp(tester);

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

  expect(find.text('0'), findsOneWidget, reason: location);
}
