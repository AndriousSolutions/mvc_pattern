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

import 'package:flutter_test/flutter_test.dart' show expect, isInstanceOf;

import 'package:mvc_pattern/mvc_pattern.dart' show StateListener, StateMVC;

import '../example/main.dart' show ListenTester;

void testsListeners(StateMVC? stateObj) {
  //
  expect(stateObj, isInstanceOf<StateMVC>());

  final listener = ListenTester();

  var added = stateObj?.addAfterListener(listener);

  expect(added, isInstanceOf<bool>());

  added = stateObj?.addBeforeListener(listener);

  expect(added, isInstanceOf<bool>());

  added = stateObj?.addListener(listener);

  expect(added, isInstanceOf<bool>());

  added = stateObj?.beforeContains(listener);

  expect(added, isInstanceOf<bool>());

  added = stateObj?.afterContains(listener);

  expect(added, isInstanceOf<bool>());

  var obj = stateObj?.beforeListener(listener.keyId);

  expect(obj, isInstanceOf<StateListener>());

  obj = stateObj?.afterListener(listener.keyId);

  expect(obj, isInstanceOf<StateListener>());
}