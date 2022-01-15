// Copyright 2018 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

import 'package:flutter_test/flutter_test.dart'
    show Future, expect, isNotEmpty, isInstanceOf;

Future<void> testsStateMVC(StateMVC? stateObj) async {
  //
  expect(stateObj, isInstanceOf<AppStateMVC>());

  ControllerMVC con = stateObj!.controller!;

  expect(con, isInstanceOf<AppController>());

  /// This Controller's current State object is _MyAppState as AppStateMVC
  stateObj = con.state;

  expect(stateObj, isInstanceOf<AppStateMVC>());

  /// The first State object is itself --- _MyAppState
  AppStateMVC appState = stateObj!.rootState!;

  expect(appState, isInstanceOf<AppStateMVC>());

  /// Every StateMVC and ControllerMVC has a unique String identifier.
  final myAppStateId = appState.keyId;

  BuildContext context = appState.context;

  expect(context, isInstanceOf<BuildContext>());

  /// A Controller for the 'app level' to influence the whole app.
  con = appState.controller!;

  expect(con, isInstanceOf<AppController>());

  String keyId = con.keyId;

  con = appState.controllerById(keyId)!;

  expect(con, isInstanceOf<AppController>());

  /// Its a special Controller of type 'AppControllerMVC'
  expect(con, isInstanceOf<AppControllerMVC>());

  /// As well as the base class, ControllerMVC
  expect(con, isInstanceOf<ControllerMVC>());

  /// You can retrieve a State object by the 'type' of its StatefulWidget
  appState = con.stateOf<MyApp>() as AppStateMVC;

  expect(appState, isInstanceOf<AppStateMVC>());

  /// The 'state' property is the Controller's current State object
  /// it is working with.
  stateObj = con.state!;

  /// Of course, Flutter provides a reference to the StatefulWidget
  /// thought the State object.
  StatefulWidget widget = stateObj.widget;

  expect(widget, isInstanceOf<MyApp>());

  /// Returns the most recent BuildContext/Element created in the App
  context = appState.lastContext!;

  expect(context, isInstanceOf<BuildContext>());

  /// Page 1 is currently being displayed.
  expect(context.widget, isInstanceOf<Page1>());

  /// If the State object has 'added' it, you can retrieve one of its
  /// Controllers by type.
  con = appState.controllerByType<Controller>()!;

  /// We know Controller's current State object is _Page1State
  stateObj = con.state;

  /// This is confirmed by testing for its StatefulWidget
  expect(stateObj!.widget, isInstanceOf<Page1>());

  /// Of course, you can retrieve the State object its currently colledted.
  /// In this case, there's only one, the one in con.state.
  StateMVC state = con.stateOf<Page1>()!;

  /// Test looking up State objects by id.
  /// The unique key identifier for this State object.
  String keyIdPage1 = state.keyId;

  /// Returns the StateMVC object using an unique String identifiers.
  stateObj = appState.getState(keyIdPage1)!;

  expect(stateObj.widget, isInstanceOf<Page1>());

  /// If you know their identifiers, you can retrieve a Map of StateMVC objects.
  Map<String, StateMVC> map = appState.getStates([myAppStateId, keyIdPage1]);

  StateMVC? state02 = map[myAppStateId];

  expect(state02, isInstanceOf<AppStateMVC>());

  expect(state02!.widget, isInstanceOf<MyApp>());

  state02 = map[keyIdPage1];

  expect(state02, isInstanceOf<StateMVC>());

  expect(state02!.widget, isInstanceOf<Page1>());

  /// Returns a List of StateView objects using unique String identifiers.
  final list = appState.listStates([myAppStateId, keyIdPage1]);

  state02 = list[0];

  expect(state02, isInstanceOf<AppStateMVC>());

  expect(state02.widget, isInstanceOf<MyApp>());

  state02 = list[1];

  expect(state02, isInstanceOf<StateMVC>());

  expect(state02.widget, isInstanceOf<Page1>());

  /// Determines if running in an IDE or in production.
  /// Returns true if the App is under in the Debugger and not production.
  final debugging = appState.inDebugger && con.inDebugger;

  expect(debugging, isInstanceOf<bool>());

  /// The State object. (con.state as StateMVC will work!)
  final _state = con.state!;

  expect(_state, isInstanceOf<State>());

  /// Test for the unique identifier assigned to every Controller.
  var id = stateObj.add(TestingController());

  expect(id, isInstanceOf<String>());

  expect(id, isNotEmpty);

  /// Is the widget mounted?
  final mounted = stateObj.mounted;

  expect(mounted, isInstanceOf<bool>());

  /// Usually you would call this function on a subclass of StateMVC
  /// We're testing the very class, StateMVC, itself and so the warning if fine:
  /// The member 'xxxxxxx' can only be used within instance members
  /// of subclasses of 'package:mvc_pattern/mvc_pattern.dart'.
  bool? boolean = await stateObj.didPopRoute();

  expect(boolean, isInstanceOf<bool>());

  boolean = await stateObj.didPushRoute('/');

  expect(boolean, isInstanceOf<bool>());

  widget = stateObj.widget;

  /// You're going to get these 'hints' or warnings because
  /// the testing is dealing with the StateMVC object directly.
  /// Normally, when using this package, you would be dealing with only
  /// the subclass of this class. Perfectly fine. Ignore them here.
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
