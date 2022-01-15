// Copyright 2018 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

void testsController(StateMVC? stateObj) {
  //
  expect(stateObj!.widget, isInstanceOf<MyApp>());

  /// Returns the unique identifier assigned to the Controller object.
  /// Unnecessary. Merely demonstrating an alternative to 'adding' a
  /// Controller object to a StatMVC object.
  /// In fact, it's already there and will merely return its assigned id.
  String conId = stateObj.add(Controller());

  expect(conId, isInstanceOf<String>(), reason: 'The unique key identifier.');

  Controller con = stateObj.controllerById(conId) as Controller;

  expect(con, isInstanceOf<Controller>(),
      reason: 'Supply the id to other developers');

  AppStateMVC appState = con.rootState!;

  /// This State object 'contains' this Controller.
  con = appState.controllerByType<Controller>()!;

  String keyId = con.keyId;

  con = appState.controllerById(keyId) as Controller;

  expect(con, isInstanceOf<Controller>());

  List<String> keyIds = stateObj.addList([Controller()]);

  expect(keyIds, isNotEmpty);

  con = stateObj.controllerById(keyIds[0]) as Controller;

  expect(con, isInstanceOf<Controller>(),
      reason: 'Supply the id to other developers');

  appState = stateObj.rootState!;

  expect(appState.widget, isInstanceOf<MyApp>());

  /// The first Controller added to the App's first State object
  final rootCon = appState.rootCon;

  expect(rootCon, isInstanceOf<AppController>());

  /// This State object 'contains' this Controller.
  AnotherController another = appState.controllerByType<AnotherController>()!;

  keyId = another.keyId;

  another = appState.controllerById(keyId) as AnotherController;

  expect(another, isInstanceOf<AnotherController>());

  /// This State object 'contains' this Controller.
  YetAnotherController andAnother =
      appState.controllerByType<YetAnotherController>()!;

  keyId = andAnother.keyId;

  andAnother = appState.controllerById(keyId) as YetAnotherController;

  expect(andAnother, isInstanceOf<YetAnotherController>());

  /// Another way to retrieve its Controller from a list of Controllers
  /// Retrieve it by 'type'
  /// This controller exists but not with this State object
  /// but with the AppMVC (the App's State object)
  another = stateObj.controllerByType<AnotherController>()!;

  expect(another, isInstanceOf<AnotherController>());

  /// This Controller will be found in this State object's listing.
  con = stateObj.controllerByType<Controller>()!;

  expect(con, isInstanceOf<Controller>());

  conId = con.keyId;

  /// Another way to retrieve its Controller from a list of Controllers
  /// Retrieve it by its key id Note the casting.
  con = stateObj.controllerById(conId) as Controller;

  expect(con, isInstanceOf<Controller>());

  /// Return a List of Controllers specified by key id.
  final listCons = con.listControllers([conId]);

  expect(listCons, isInstanceOf<List<ControllerMVC?>>());

  expect(listCons[0], isInstanceOf<Controller>());

  /// Only when the [StateMVC] object is first created.
  con.initState();

  /// The framework calls this method when removed from the widget tree.
  /// Called when there's a hot reload.
  con.deactivate();

  /// The framework calls this method the State object is terminated.
  con.dispose();

  /// Called if the State object was a dependency to an InheritedWidget
  /// and that InheritedWidget has been rebuilt. Hence this is rebuilt.
  con.didChangeDependencies();

  /// Called during development whenever there's a hot reload.
  con.reassemble();

  /// When the framework tells the app to pop the current route.
  con.didPopRoute();

  /// When the application's dimensions change.
  con.didChangeMetrics();

  /// Called when the platform's text scale factor changes.
  con.didChangeTextScaleFactor();

  /// Brightness changed.
  con.didChangePlatformBrightness();

  /// Called when the system is running low on memory.
  con.didHaveMemoryPressure();

  /// Called when the system changes the set of active accessibility features.
  con.didChangeAccessibilityFeatures();

  /// Allows you to call 'setState' from the 'current' the State object.
  con.setState(() {});

  /// Allows you to call 'setState' from the 'current' the State object.
  con.refresh();

  /// Allows you to call 'setState' from the 'current' the State object.
  con.rebuild();

  /// Allows you to call 'setState' from the 'current' the State object.
  con.notifyListeners();

  /// Return a 'copy' of the Set of State objects.
  final Set<StateMVC>? states = con.states;

  expect(states, isInstanceOf<Set<StateMVC>>());
}
