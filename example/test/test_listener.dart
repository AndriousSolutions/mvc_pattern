// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// ignore_for_file: INVALID_USE_OF_PROTECTED_MEMBER

import 'package:flutter_test/flutter_test.dart';

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

/// A 'listener' for testing.
class TesterStateListener with StateListener {
  factory TesterStateListener() => _this ??= TesterStateListener._();
  TesterStateListener._();
  static TesterStateListener? _this;
}

//
const _location = '========================== test_listener.dart';

Future<void> testsStateListener01(WidgetTester tester) async {
  //
  /// Find its StatefulWidget first then the 'type' of State object.
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

  /// Testing the Adding of Listeners to a State object

  var added = state.addBeforeListener(listener);

  expect(added, isTrue, reason: _location);

  /// Test for 'Before' Listener has been added.
  var contains = state.beforeContains(listener);

  expect(contains, isTrue, reason: _location);

  /// Add an 'after' Listener.
  state.addAfterListener(listener);

  /// Test for 'After' Listener has been added.
  contains = state.afterContains(listener);

  expect(contains, isTrue, reason: _location);

  final add = state.addListener(listener);

  expect(add, isFalse, reason: _location);

  var stateListener = state.beforeListener(id);

  stateListener = state.afterListener(id)!;

  expect(stateListener, isA<TesterStateListener>(), reason: _location);

  stateListener = con.beforeListener(id);

  expect(stateListener, isA<TesterStateListener>(), reason: _location);

  stateListener = con.afterListener(id);

  expect(stateListener, isA<TesterStateListener>(), reason: _location);

  var list = state.beforeList([id]);

  list = state.afterList([id]);

  expect(list, isNotEmpty, reason: _location);
}

Future<void> testsStateListener02(WidgetTester tester) async {
  //
  /// Find the 'first State object' of the App.
  /// Find its StatefulWidget first then the 'type' of State object.
  final appState = tester.firstState<AppStateMVC>(find.byType(MyApp));

  expect(appState.widget, isA<MyApp>());

  /// If the State object has 'added' it, you can retrieve one of its
  /// Controllers by type.
  final con = appState.controllerByType<Controller>()!;

  /// Of course, you can retrieve the State object its currently collected.
  /// In this case, there's only one, the one in con.state.
  StateMVC state = con.stateOf<Page1>()!;

  /// The Test Listener
  final listener = TesterStateListener();

  var add = state.addListener(listener);

  expect(add, isTrue, reason: _location);

  // Add the listener as a 'before' listener
  add = state.addBeforeListener(listener);

  expect(add, isTrue, reason: _location);

  var removed = state.removeListener(listener);

  expect(removed, isTrue, reason: _location);

  // Add again for further testing that follows.
  add = state.addListener(listener);

  expect(add, isTrue, reason: _location);

  // 'addListener' adds an 'after' listener
  // Should return false as it's already added.
  add = state.addAfterListener(listener);

  expect(add, isFalse, reason: _location);

  // Add again for further testing that follows.
  add = state.addBeforeListener(listener);

  expect(add, isTrue, reason: _location);
}
