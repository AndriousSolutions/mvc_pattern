/// Note: This license has also been called the "Simplified BSD License" and the "FreeBSD License".
/// See also the 2-clause BSD License.
///
/// Copyright 2018 www.andrioussolutions.com
///
/// Redistribution and use in source and binary forms, with or without modification,
/// are permitted provided that the following conditions are met:
///
/// 1. Redistributions of source code must retain the above copyright notice,
/// this list of conditions and the following disclaimer.
///
/// 2. Redistributions in binary form must reproduce the above copyright notice,
/// this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
///
/// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
/// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
/// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
/// IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
/// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
/// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
/// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
/// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
/// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
/// EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

/// The 'show' clause is not essential. Merely for your reference.
import 'package:flutter/material.dart' show AppLifecycleState, Localizations;

/// The 'show' clause is not essential. Merely for your reference.
import 'package:flutter_test/flutter_test.dart'
    show Future, expect, isNotEmpty, isInstanceOf;

/// The 'show' clause is not essential. Merely for your reference.
import 'package:mvc_pattern/mvc_pattern.dart'
    show ControllerMVC, StateMVC, AppControllerMVC;

/// The 'show' clause is not essential. Merely for your reference.
import '../example/main.dart' show Controller, MyHomePageState;

Future<void> testsStateMVC(StateMVC? stateObj) async {
  //
  expect(stateObj, isInstanceOf<MyHomePageState>());

  final con = stateObj?.controller;

  expect(con, isInstanceOf<Controller>());

  /// The StateMVC object.
  final _stateMVC = con?.state;

  expect(_stateMVC, isInstanceOf<MyHomePageState>());

  /// The State object. (con.state as StateMVC will work!)
  final _state = con?.state!;

  expect(_state, isInstanceOf<MyHomePageState>());

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
