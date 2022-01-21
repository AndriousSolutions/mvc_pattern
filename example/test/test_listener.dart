// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// ignore_for_file: INVALID_USE_OF_PROTECTED_MEMBER

import 'package:flutter_test/flutter_test.dart';

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

/// Assign the mixin to be tested.
class TesterStateListener with StateListener {}

Future<void> testsStateListener(WidgetTester tester) async {
  //
  const location = '========================== test_listener.dart';

  /// Explicitly provide what's intentionally should be accessible
  /// but is made accessible for 'internal testing' of this framework.
  // Find its StatefulWidget first then the 'type' of State object.
  final appState = tester.firstState<AppStateMVC>(find.byType(MyApp));

  expect(appState.widget, isA<MyApp>());

  /// If the State object has 'added' it, you can retrieve one of its
  /// Controllers by type.
  final con = appState.controllerByType<Controller>()!;

  /// Of course, you can retrieve the State object its currently colledted.
  /// In this case, there's only one, the one in con.state.
  StateMVC state = con.stateOf<Page1>()!;

  final listener = TesterStateListener();

  final id = listener.keyId;

  var added = state.addBeforeListener(listener);

  expect(added, isTrue, reason: location);

  var contains = state.beforeContains(listener);

  expect(contains, isTrue, reason: location);

  state.addAfterListener(listener);

  contains = state.afterContains(listener);

  expect(contains, isTrue, reason: location);

  final add = state.addListener(listener);

  expect(add, isFalse, reason: location);

  var stateListener = state.beforeListener(id);

  stateListener = state.afterListener(id)!;

  expect(stateListener, isA<TesterStateListener>(), reason: location);

  stateListener = con.beforeListener(id);

  expect(stateListener, isA<TesterStateListener>(), reason: location);

  stateListener = con.afterListener(id);

  expect(stateListener, isA<TesterStateListener>(), reason: location);

  var list = state.beforeList([id]);

  list = state.afterList([id]);

  expect(list, isNotEmpty, reason: location);

  var controller = state.firstCon;

  expect(controller, isA<ControllerMVC>(), reason: location);

  final debug = state.inDebugger;

  expect(debug, isA<bool>(), reason: location);

  bool? boolean = await state.didPopRoute();

  expect(boolean, isFalse, reason: location);

  boolean = await state.didPushRoute('/');

  expect(boolean, isFalse, reason: location);

  final widget = state.widget;

  state.didUpdateWidget(widget);

  final context = state.context;

  final locale = Localizations.localeOf(context);

  /// Called when the app's Locale changes
  state.didChangeLocale(locale);

  /// Called when the returning from another app.
  state.didChangeAppLifecycleState(AppLifecycleState.resumed);

  state.reassemble();

  state.deactivate();

  /// They have to be returned after a 'deactivate' in testing.
  state.add(con);

  /// null testing
  state.add(null);

  state.didChangeMetrics();

  state.didChangeTextScaleFactor();

  state.didChangePlatformBrightness();

  state.didHaveMemoryPressure();

  state.didChangeAccessibilityFeatures();

  state.refresh();

  final removed = state.removeListener(listener);

  expect(removed, isTrue, reason: location);
}
