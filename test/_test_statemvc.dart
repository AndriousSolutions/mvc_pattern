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

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:mvc_pattern/mvc_pattern.dart';

import '../example/main.dart';

Future<void> testsStateMVC(StateMVC? stateObj) async {
  //
  expect(stateObj, isInstanceOf<StateMVC>());

  var con = stateObj?.controller;

  expect(con, isInstanceOf<ControllerMVC>());

  /// The StateMVC object.
  final _stateMVC = con?.stateMVC;

  expect(_stateMVC, isInstanceOf<State<StatefulWidget>>());

  /// The State object. (con.state as StateMVC will work!)
  final _state = con?.state!;

  expect(_state, isInstanceOf<State>());

  /// Test adding null. Should return an empty string.
  var id = _stateMVC?.add(null);

  expect(id, isInstanceOf<String>());

  expect(id, isEmpty);

  _stateMVC?.add(FakeController());

  /// Return a List of Controllers specified by key id.
  final listCons =
  _stateMVC?.listControllers([Controller().keyId, FakeController().keyId]);

  expect(listCons, isInstanceOf<List<ControllerMVC?>>());

  final map = _stateMVC?.map;

  expect(map, isInstanceOf<Map<String, ControllerMVC>>());

  final remove = _stateMVC?.remove(FakeController().keyId);

  expect(remove, isInstanceOf<bool>());

  con = _stateMVC?.firstCon;

  expect(con, isInstanceOf<ControllerMVC>());

  /// Controller's unique identifier.
  id = con?.keyId;

  expect(id, isInstanceOf<String>());

  /// The StateView's unique identifier.
  final svId = _stateMVC?.keyId;

  expect(svId, isInstanceOf<String>());

  /// Will get an error because its unmounted.
  // /// Current context.
  // final context = _stateMVC?.context;
  //
  // expect(context, isInstanceOf<BuildContext>());

  /// Is the widget mounted?
  final mounted = _stateMVC?.mounted;

  expect(mounted, isInstanceOf<bool>());

  // /// The StatefulWidget.
  // final widget = _stateMVC?.widget;
  //
  // expect(widget, isInstanceOf<StatefulWidget>());

  final listenId = ListenTester().keyId;

  var add = _stateMVC?.addBeforeListener(ListenTester());

  expect(add, isInstanceOf<bool>());

  add = _stateMVC?.addBeforeListener(ListenTester());

  expect(add, isInstanceOf<bool>());

  var list = _stateMVC?.beforeList([listenId]);

  expect(list, isInstanceOf<List<StateListener>>());

  list = _stateMVC?.afterList([listenId]);

  expect(list, isInstanceOf<List<StateListener>>());

  var boolean = await stateObj?.initAsync();

  expect(boolean, isInstanceOf<bool>());

  /// Usually you would call this function on a subclass of StateMVC
  /// For example, _MyHomePageState would have this function.
  boolean = await stateObj?.didPopRoute();

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

//  stateObj?.didChangeLocale(locale);

//  stateObj?.didChangeAppLifecycleState(state);

  stateObj?.didHaveMemoryPressure();

  stateObj?.didChangeAccessibilityFeatures();

  stateObj?.refresh();

  final exception = FlutterErrorDetails(exception: Exception('Error Test!'));

  stateObj?.onError(exception);

  stateObj?.onAsyncError(exception);
}
