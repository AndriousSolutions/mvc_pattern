// Copyright 2018 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// ignore_for_file: INVALID_USE_OF_PROTECTED_MEMBER

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart';

Future<void> testsStateMVC(WidgetTester tester) async {
  //
  const location = '========================== test_statemvc.dart';

  /// Explicitly provide what's intentionally should be accessible
  /// but is made accessible for 'internal testing' of this framework.
  // Find its StatefulWidget first then the 'type' of State object.
  StateMVC stateObj = tester.firstState<AppStateMVC>(find.byType(MyApp));

  expect(stateObj, isA<AppStateMVC>(), reason: location);

  ControllerMVC con = stateObj.controller!;

  expect(con, isA<AppController>());

  /// This Controller's current State object is _MyAppState as AppStateMVC
  stateObj = con.state!;

  expect(stateObj, isA<AppStateMVC>(), reason: location);

  /// The first State object is itself --- _MyAppState
  AppStateMVC appState = stateObj.rootState!;

  expect(appState, isA<AppStateMVC>(), reason: location);

  /// Test its if statement.
  appState.catchError(null);

  /// Every StateMVC and ControllerMVC has a unique String identifier.
  final myAppStateId = appState.keyId;

  BuildContext context = appState.context;

  expect(context, isA<BuildContext>(), reason: location);

  /// A Controller for the 'app level' to influence the whole app.
  con = appState.controller!;

  expect(con, isA<AppController>(), reason: location);

  String keyId = con.keyId;

  con = appState.controllerById(keyId)!;

  expect(con, isA<AppController>(), reason: location);

  /// Its a special Controller of type 'AppControllerMVC'
  expect(con, isA<AppControllerMVC>(), reason: location);

  /// As well as the base class, ControllerMVC
  expect(con, isA<ControllerMVC>(), reason: location);

  /// You can retrieve a State object by the 'type' of its StatefulWidget
  appState = con.stateOf<MyApp>() as AppStateMVC;

  expect(appState, isA<AppStateMVC>(), reason: location);

  /// The 'state' property is the Controller's current State object
  /// it is working with.
  stateObj = con.state!;

  /// Of course, Flutter provides a reference to the StatefulWidget
  /// thought the State object.
  StatefulWidget widget = stateObj.widget;

  expect(widget, isA<MyApp>(), reason: location);

  /// Returns the most recent BuildContext/Element created in the App
  context = appState.lastContext!;

  if (context.widget is Page1) {
    /// Page 1 is currently being displayed.
    expect(context.widget, isA<Page1>(), reason: location);

    /// We know Controller's current State object is _Page1State
    stateObj = con.state!;

    /// This is confirmed by testing for its StatefulWidget
    expect(stateObj.widget, isA<Page1>(), reason: location);
  }

  if (context.widget is MyHomePage) {
    /// MyHomePage is currently being displayed.
    expect(context.widget, isA<MyHomePage>(), reason: location);

    /// We know Controller's current State object is _MyHomePageState
    stateObj = con.state!;

    /// This is confirmed by testing for its StatefulWidget
    expect(stateObj.widget, isA<MyApp>(), reason: location);
  }

  /// If the State object has 'added' it, you can retrieve one of its
  /// Controllers by type.
  con = appState.controllerByType<Controller>()!;

  /// Of course, you can retrieve the State object its collected.
  /// In this case, there's only one, the one in con.state.
  StateMVC state = con.stateOf<Page1>()!;

  /// Test looking up State objects by id.
  /// The unique key identifier for this State object.
  String keyIdPage1 = state.keyId;

  /// Returns the StateMVC object using an unique String identifiers.
  stateObj = appState.getState(keyIdPage1)!;

  expect(stateObj.widget, isA<Page1>(), reason: location);

  /// If you know their identifiers, you can retrieve a Map of StateMVC objects.
  Map<String, StateMVC> map = appState.getStates([myAppStateId, keyIdPage1]);

  StateMVC? state02 = map[myAppStateId];

  expect(state02, isA<AppStateMVC>(), reason: location);

  expect(state02!.widget, isA<MyApp>(), reason: location);

  state02 = map[keyIdPage1];

  expect(state02, isA<StateMVC>(), reason: location);

  expect(state02!.widget, isA<Page1>(), reason: location);

  /// Returns a List of StateView objects using unique String identifiers.
  final list = appState.listStates([myAppStateId, keyIdPage1]);

  state02 = list[0];

  expect(state02, isA<AppStateMVC>(), reason: location);

  expect(state02.widget, isA<MyApp>(), reason: location);

  state02 = list[1];

  expect(state02, isA<StateMVC>(), reason: location);

  expect(state02.widget, isA<Page1>(), reason: location);

  /// Determines if running in an IDE or in production.
  /// Returns true if the App is under in the Debugger and not production.
  final debugging = appState.inDebugger && con.inDebugger;

  expect(debugging, isA<bool>(), reason: location);

  /// The State object. (con.state as StateMVC will work!)
  final _state = con.state!;

  expect(_state, isA<State>(), reason: location);

  /// Test for the unique identifier assigned to every Controller.
  var id = stateObj.add(TestingController());

  expect(id, isA<String>(), reason: location);

  expect(id, isNotEmpty, reason: location);

  final removed = stateObj.remove(id);

  expect(removed, isTrue, reason: location);

  /// Is the widget mounted?
  final mounted = stateObj.mounted;

  expect(mounted, isA<bool>(), reason: location);

  /// Usually you would call this function on a subclass of StateMVC
  /// We're testing the very class, StateMVC, itself and so the warning if fine:
  /// The member 'xxxxxxx' can only be used within instance members
  /// of subclasses of 'package:mvc_pattern/mvc_pattern.dart'.
  bool? boolean = await stateObj.didPopRoute();

  expect(boolean, isA<bool>(), reason: location);

  boolean = await stateObj.didPushRoute('/');

  expect(boolean, isA<bool>(), reason: location);

  widget = stateObj.widget;

  /// You're going to get these 'hints' or warnings because
  /// the testing is dealing with the StateMVC object directly.
  /// Normally, when using this package, you would be dealing with only
  /// the subclass of this class. Perfectly fine.
  ///
  /// The member 'xxxxxx' can only be used within instance members
  /// of subclasses of 'package:mvc_pattern/mvc_pattern.dart

  stateObj.didUpdateWidget(widget);

  context = stateObj.context;

  final locale = Localizations.localeOf(context);

  /// You're going to get these 'hints' or warnings because
  /// the testing is dealing with the StateMVC object directly.
  /// Normally, when using this package, you would be dealing with only
  /// the subclass of this class. Perfectly fine. Ignore them here.
  ///
  /// The member 'xxxxxx' can only be used within instance members
  /// of subclasses of 'package:mvc_pattern/mvc_pattern.dart

  /// Called when the app's Locale changes
  stateObj.didChangeLocale(locale);

  /// Called when the returning from another app.
  stateObj.didChangeAppLifecycleState(AppLifecycleState.resumed);

  stateObj.reassemble();

  stateObj.deactivate();

  stateObj.didChangeMetrics();

  stateObj.didChangeTextScaleFactor();

  stateObj.didChangePlatformBrightness();

  stateObj.didHaveMemoryPressure();

  stateObj.didChangeAccessibilityFeatures();

  stateObj.refresh();
}

/// Merely a 'tester' Controller used in the function above.
class TestingController extends ControllerMVC with AppControllerMVC {
  factory TestingController() => _this ??= TestingController._();
  TestingController._();
  static TestingController? _this;
}
