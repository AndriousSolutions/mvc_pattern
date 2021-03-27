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

import 'package:flutter/material.dart' show FlutterErrorDetails;

import 'package:flutter_test/flutter_test.dart' show expect, isInstanceOf;

import 'package:mvc_pattern/mvc_pattern.dart'
    show ControllerMVC, StateListener, StateMVC;

import '../example/main.dart'
    show Controller, FakeAppController, ListenTester, SecondState;

void testsController(StateMVC? stateObj) {
  //
  expect(stateObj, isInstanceOf<StateMVC>());

  /// Returns the unique identifier assigned to the Controller object.
  /// Unnecessary. Merely demonstrating an alternative to 'adding' a
  /// Controller object to a StatMVC object so to use its properties and functions.
  /// It, in fact, won't be added to the Set.
  var conId = stateObj?.add(Controller());

  expect(conId, isInstanceOf<String>(), reason: 'The unique key identifier.');

  stateObj?.addList([Controller()]);

  /// Another way to retrieve its Controller from a list of Controllers
  /// Retrieve it by 'type'
  /// This controller exists but not with this State object
  /// but with the AppMVC (the App's State object)
  final appController = stateObj?.controllerByType<FakeAppController>();

  expect(appController, isInstanceOf<FakeAppController>());

  /// This Controller will be found in this State object's listing.
  var conObj = stateObj?.controllerByType<Controller>();

  expect(conObj, isInstanceOf<Controller>());

  conId = conObj?.keyId;

  /// Another way to retrieve its Controller from a list of Controllers
  /// Retrieve it by its key id Note the casting.
  /// The function controllerById returns an object of type ControllerMVC.
  conObj = stateObj?.controllerById(conId!) as Controller;

  expect(conObj, isInstanceOf<Controller>());

  /// Return a List of Controllers specified by key id.
  final listCons = conObj.listControllers([conId!]);

  expect(listCons, isInstanceOf<List<ControllerMVC?>>());

  /// This listener object has a factory constructor and so
  /// has already been instantiated. It's here to provide
  /// its unique key identifier.
  final listener = ListenTester();

  /// Retrieve the 'before' listener by its unique key.
  /// The very same listener instantiated above.
  var listenerObj = conObj.beforeListener(listener.keyId);

  expect(listenerObj, isInstanceOf<StateListener?>());

  /// Retrieve the 'before' listener by its unique key.
  /// The very same listener instantiated above.
  listenerObj = conObj.afterListener(listener.keyId);

  expect(listenerObj, isInstanceOf<StateListener?>());

  /// Only when the [StateMVC] object is first created.
  conObj.initState();

  /// The framework calls this method when removed from the widget tree.
  conObj.deactivate();

  /// Called during development whenever there's a hot reload.
  conObj.reassemble();

  /// Allows you to call 'setState' from the 'current' the State object.
  conObj.setState(() {});

  /// Allows you to call 'setState' from the 'current' the State object.
  conObj.refresh();

  /// Allows you to call 'setState' from the 'current' the State object.
  conObj.rebuild();

  /// Allows you to call 'setState' from the 'current' the State object.
  conObj.notifyListeners();

  /// Return a 'copy' of the Set of State objects.
  final Set<StateMVC> states = conObj.states;

  expect(states, isInstanceOf<Set<StateMVC>>());

  /// The current StateMVC object.
  final state = conObj.stateMVC;

  /// Remove the specified StateMVC object to a Set of such objects
  var result = conObj.removeState(state);

  expect(result, isInstanceOf<bool>());

  result = conObj.removeState(SecondState());

  expect(result, isInstanceOf<bool>());

  result = conObj.pushState(state);

  expect(result, isInstanceOf<bool>());

  conObj.addState(state);

  final exception = FlutterErrorDetails(exception: Exception('Error Test!'));

  FakeAppController().onError(exception);
}
