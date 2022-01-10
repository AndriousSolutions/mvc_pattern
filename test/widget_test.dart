// Copyright 2018 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

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

//ignore: avoid_relative_lib_imports
import '../example/lib/src/app/view/my_app.dart';

//ignore: avoid_relative_lib_imports
import '../example/lib/src/home/controller/another_controller.dart';

//ignore: avoid_relative_lib_imports
import '../example/lib/src/home/view/my_home_page.dart';

//ignore: avoid_relative_lib_imports
import '../example/lib/src/view.dart';

import '_test_controller.dart' show testsController;

import '_test_statemvc.dart' show testsStateMVC;

void main() {
  // Use a key to locate the widget you need to test
  final Key key = UniqueKey();
  _testApp(key, MyApp(key: key) as AppStatefulWidgetMVC);
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
    final keyId = stateObj?.keyId;

    /// Returns a Map of StateView objects using unique String identifiers.
    final map = AppStatefulWidgetMVC.getStates([keyId!]);

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
//    await testsStateMVC(stateObj);

    /// Tests Controller object
//    testsController(stateObj);

    expect(find.text('Hello there!'), findsNothing);

    // Retrieve the 'View' State object linked to this Controller.
    final MyAppState? vw = con!.rootState as MyAppState?;

//    final state = con.stateOf<MyApp>();

    /// The first Controller added to the App's first State object
    final firstCon = (vw as StateMVC).firstCon;

    expect(firstCon, isInstanceOf<AnotherController>());

    (vw as StateMVC).dataObject = 'Hello there!';

    /// Another means to 'refresh' the View object
    (vw as StateMVC).refresh();
    await tester.pump();

    expect(find.text('Hello there!'), findsOneWidget);
  });
}
