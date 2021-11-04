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
import 'package:flutter/material.dart' show BuildContext, Icons, Key, UniqueKey;

/// The 'show' clause is not essential. Merely for your reference.
import 'package:flutter_test/flutter_test.dart'
    show
        WidgetTester,
        expect,
        find,
        findsNothing,
        findsOneWidget,
        isInstanceOf,
        testWidgets;

/// The 'show' clause is not essential. Merely for your reference.
import 'package:mvc_pattern/mvc_pattern.dart'
    show AppControllerMVC, AppStatefulWidgetMVC, ControllerMVC, StateMVC;

import '../example/main.dart'
    show AnotherController, MyApp, MyHomePageState, View;

import '_test_controller.dart' show testsController;

/// The 'show' clause is not essential. Merely for your reference.

import '_test_statemvc.dart' show testsStateMVC;

void main() {
  // Use a key to locate the widget you need to test
  final Key key = UniqueKey();
  _testApp(key, MyApp(key: key));
}

void _testApp(Key key, AppStatefulWidgetMVC app) {
  //
  testWidgets('test mvc_pattern', (WidgetTester tester) async {
    // Tells the tester to build a UI based on the widget tree passed to it
    await tester.pumpWidget(app);

    /// You can directly access the 'internal workings' of the app!
    /// Main or first class to pass to the 'main.dart' file's runApp() function.
    /// AppStatefulWidget is its subclass.
    final AppStatefulWidgetMVC appMVC = tester.widget(find.byKey(key));

    expect(appMVC, isInstanceOf<AppStatefulWidgetMVC>());

    /// Returns the most recent BuildContext/Element created in the App
    final context = appMVC.context;

    expect(context, isInstanceOf<BuildContext?>());

    /// A Controller for the 'app level' to influence the whole app.
    /// Its a special Controller of type 'AppControllerMVC?.'
    final con = appMVC.con;

    expect(con, isInstanceOf<AppControllerMVC?>());

    /// Return the special controller of type 'AppControllerMVC?'
    /// but as a type ControllerMVC? instead.
    final controller = appMVC.controller;

    expect(controller, isInstanceOf<ControllerMVC?>());

    /// Both are of type, AnotherController, defined in the app.
    expect(con, isInstanceOf<AnotherController>());
    expect(controller, isInstanceOf<AnotherController>());

    /// Returns the Home Screen's StateMVC object
    final StateMVC? stateObj =
        AppStatefulWidgetMVC.getState(MyApp.homeStateKey!);

    expect(stateObj, isInstanceOf<StateMVC>());

    /// Test looking up State objects by id.
    /// The unique key identifier for this State object.
    final keyId = MyHomePageState().keyId;

    /// Returns a Map of StateView objects using unique String identifiers.
    final map = AppStatefulWidgetMVC.getStates([keyId]);

    expect(map, isInstanceOf<Map<String, StateMVC>>());

    /// Returns a List of StateView objects using unique String identifiers.
    final list = AppStatefulWidgetMVC.listStates([keyId]);

    expect(list, isInstanceOf<List<StateMVC>>());

    /// Determines if running in an IDE or in production.
    /// Returns true if the App is under in the Debugger and not production.
    final debugging = AppStatefulWidgetMVC.inDebugger;

    expect(debugging, isInstanceOf<bool>());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);

    /// Tests StateMVC object again!
    await testsStateMVC(stateObj);

    /// Tests Controller object
    testsController(stateObj);

    expect(find.text('Hello there!'), findsNothing);

    // Retrieve the 'View' State object linked to this Controller.
    final View? vw = con!.ofState<View>();

    /// The first Controller added to the App's first State object
    final firstCon = vw!.firstCon;

    expect(firstCon, isInstanceOf<AnotherController>());

    vw.dataObject = 'Hello there!';

    /// Another means to 'refresh' the View object
    vw.refresh();
    await tester.pump();

    expect(find.text('Hello there!'), findsOneWidget);
  });
}
