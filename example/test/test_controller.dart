// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';

import 'package:example/src/controller.dart';

import 'package:example/src/view.dart';

const location = '========================== test_controller.dart';

void testsController(WidgetTester tester) {
  //

  /// Explicitly provide what's intentionally should be accessible
  /// but is made accessible for 'internal testing' of this framework.
  // Find its StatefulWidget first then the 'type' of State object.
  AppStateMVC appState = tester.firstState<AppStateMVC>(find.byType(MyApp));

  expect(appState.widget, isA<MyApp>());

  /// Returns the unique identifier assigned to the Controller object.
  /// Unnecessary. Merely demonstrating an alternative to 'adding' a
  /// Controller object to a StatMVC object.
  /// In fact, it's already there and will merely return its assigned id.
  String conId = appState.add(Controller());

  expect(conId, isA<String>(), reason: location);

  Controller con = appState.controllerById(conId) as Controller;

  expect(con, isA<Controller>(), reason: location);

  /// Do the reverse, test 'adding' a State object to a Controller.
  conId = con.addState(appState);

  /// null testing
  conId = appState.add(null);

  expect(conId, isEmpty);

  appState = con.rootState!;

  /// This State object 'contains' this Controller.
  con = appState.controllerByType<Controller>()!;

  String keyId = con.keyId;

  con = appState.controllerById(keyId) as Controller;

  expect(con, isA<Controller>(), reason: location);

  List<String> keyIds = appState.addList([Controller()]);

  expect(keyIds, isNotEmpty, reason: location);

  con = appState.controllerById(keyIds[0]) as Controller;

  expect(con, isA<Controller>(), reason: location);

  /// Event the 'first' State object has a reference to itself
  appState = appState.rootState!;

  expect(appState.widget, isA<MyApp>(), reason: location);

  /// Returns the most recent BuildContext/Element created in the App
  BuildContext context = con.lastContext!;

  expect(context.widget, isA<Page1>(), reason: location);

  /// Call for testing coverage
  con.widgetInherited(context);

  /// Rebuild InheritedWidget
  appState.inheritedNeedsBuild('Test');

  /// Test AppController class
  _testAppController(tester);

  /// This State object 'contains' this Controller.
  AnotherController another = appState.controllerByType<AnotherController>()!;

  keyId = another.keyId;

  another = appState.controllerById(keyId) as AnotherController;

  expect(another, isA<AnotherController>(), reason: location);

  /// This State object 'contains' this Controller.
  YetAnotherController andAnother =
      appState.controllerByType<YetAnotherController>()!;

  keyId = andAnother.keyId;

  andAnother = appState.controllerById(keyId) as YetAnotherController;

  expect(andAnother, isA<YetAnotherController>(), reason: location);

  /// Another way to retrieve its Controller from a list of Controllers
  /// Retrieve it by 'type'
  /// This controller exists but not with this State object
  /// but with the AppMVC (the App's State object)
  another = appState.controllerByType<AnotherController>()!;

  expect(another, isA<AnotherController>(), reason: location);

  /// This Controller will be found in this State object's listing.
  con = appState.controllerByType<Controller>()!;

  expect(con, isA<Controller>());

  conId = con.keyId;

  /// Another way to retrieve its Controller from a list of Controllers
  /// Retrieve it by its key id Note the casting.
  con = appState.controllerById(conId) as Controller;

  expect(con, isA<Controller>(), reason: location);

  /// Return a List of Controllers specified by key id.
  final listCons = con.listControllers([conId]);

  expect(listCons, isA<List<ControllerMVC?>>(), reason: location);

  expect(listCons[0], isA<Controller>(), reason: location);

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

  expect(states, isA<Set<StateMVC>>(), reason: location);
}

bool _testAppController(WidgetTester tester) {
  bool tested = false;

  /// Explicitly provide what's intentionally should be accessible
  /// but is made accessible for 'internal testing' of this framework.
  // Find its StatefulWidget first then the 'type' of State object.
  StateMVC appState = tester.firstState<AppStateMVC>(find.byType(MyApp));

  /// The first Controller added to the App's first State object
  final controller = appState.rootCon;

  expect(controller, isA<AppController>());

  final rootCon = controller as AppController;

  final errorDetails = FlutterErrorDetails(
    exception: Exception('Pretend Error'),
    context: ErrorDescription('Created merely for testing purposes.'),
    library: 'widget_test',
  );

  expect(rootCon.onAsyncError(errorDetails), isA<bool>());

  // Take in any Exception so not to 'fail' the running test
  tester.takeException();

  return tested;
}
