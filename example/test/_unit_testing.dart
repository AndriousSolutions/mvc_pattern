// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';

import 'test_controller.dart';

import 'test_listener.dart';

import 'test_statemvc.dart';

Future<void> unitTesting(WidgetTester tester) async {
//
  /// Tests Listener class
  await testsStateListener(tester);

  /// Tests StateMVC class
  await testsStateMVC(tester);

  /// Tests ControllerMVC class
  testsController(tester);
}
