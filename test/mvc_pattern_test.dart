import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:mvc_pattern/mvc_pattern.dart';

//import 'counter_app_test.dart';
import 'counter_app_test2.dart';
//import 'counter_app_test3.dart';
//import 'counter_app_test4.dart';

void main() {
  testWidgets('Counter App Test', (WidgetTester tester) async {
    // Use a key to locate the widget you need to test
    Key key = UniqueKey();

    // Tells the tester to build a UI based on the widget tree passed to it
    await tester.pumpWidget(MyApp(key: key));

    /// You can directly access the 'internal workings' of the app!
    MyApp _app = tester.widget(find.byKey(key));

    expect(_app, isInstanceOf<AppMVC>());

    /// Reference to the Controller.
    Controller _con = _app.controller;

    expect(_con, isInstanceOf<ControllerMVC>());

    /// Reference to the StateMVC.
    StateMVC _sv = _con.stateMVC;

    expect(_sv, isInstanceOf<State<StatefulWidget>>());

    /// The State object.
    State _state = _con.stateMVC;

    expect(_state, isInstanceOf<State<StatefulWidget>>());

    /// Controller's unique identifier.
    String id = _con.keyId;

    expect(id, isInstanceOf<String>());

    /// The StateView's unique identifier.
    String svId = _sv.keyId;

    expect(svId, isInstanceOf<String>());

    /// Current context.
    BuildContext context2 = _sv.context;

    expect(context2, isInstanceOf<BuildContext>());

    /// Is the widget mounted?
    bool mounted2 = _sv.mounted;

    expect(mounted2, isInstanceOf<bool>());

    /// The StatefulWidget.
    StatefulWidget widget2 = _sv.widget;

    expect(widget2, isInstanceOf<StatefulWidget>());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    /// You can access the Controller's properties.
//    expect(_con.displayThis == 1, true);

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
