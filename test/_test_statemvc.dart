// Copyright 2018 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The 'show' clause is not essential. Merely for your reference.
import 'package:flutter_test/flutter_test.dart'
    show Future, expect, isNotEmpty, isInstanceOf;

//ignore: avoid_relative_lib_imports
import '../example/lib/src/home/controller/controller.dart';

//ignore: avoid_relative_lib_imports
import '../example/lib/src/home/view/my_home_page.dart';

//ignore: avoid_relative_lib_imports
import '../example/lib/src/view.dart';

Future<void> testsStateMVC(StateMVC? stateObj) async {
  //
  final con = stateObj?.controller;

  expect(con, isInstanceOf<Controller>());

  /// The StateMVC object.
  final _stateMVC = con?.state;

  expect(_stateMVC, isInstanceOf<StateMVC>());

  /// The State object. (con.state as StateMVC will work!)
  final _state = con?.state!;

  expect(_state, isInstanceOf<State>());

  /// Test for the unique identifier assigned to every Controller.
  var id = _stateMVC?.add(TestingController());

  expect(id, isInstanceOf<String>());

  expect(id, isNotEmpty);

  /// Is the widget mounted?
  final mounted = _stateMVC?.mounted;

  expect(mounted, isInstanceOf<bool>());

  /// Usually you would call this function on a subclass of StateMVC
  /// For example, _MyHomePageState would have this function.
  bool? boolean = await stateObj?.didPopRoute();

  expect(boolean, isInstanceOf<bool>());

  boolean = await stateObj?.didPushRoute('/');

  expect(boolean, isInstanceOf<bool>());

  final widget = stateObj?.widget;

  stateObj?.didUpdateWidget(widget!);

  final context = stateObj?.context;

  final locale = Localizations.localeOf(context!);

  /// Called when the app's Locale changes
  stateObj?.didChangeLocale(locale);

  /// Called when the returning from another app.
  stateObj?.didChangeAppLifecycleState(AppLifecycleState.resumed);

  stateObj?.reassemble();

  stateObj?.deactivate();

  stateObj?.didChangeMetrics();

  stateObj?.didChangeTextScaleFactor();

  stateObj?.didChangePlatformBrightness();

  stateObj?.didHaveMemoryPressure();

  stateObj?.didChangeAccessibilityFeatures();

  stateObj?.refresh();
}

/// Merely a 'tester' Controller used in the function above.
class TestingController extends ControllerMVC with AppControllerMVC {
  factory TestingController() => _this ??= TestingController._();
  TestingController._();
  static TestingController? _this;
}
