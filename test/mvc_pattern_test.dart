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

    /// Reference to the Controller.
    Controller _con = _app.con;

    /// Reference to the StateMVC.
    StateMVC _sv = _con.stateMVC;

    /// The State object.
    State _state = _con.stateMVC;

    /// Controller's unique identifier.
    String id = _con.keyId;

    /// The StateView's unique identifier.
    String svId = _sv.keyId;

    /// Current context.
    BuildContext context2 = _sv.context;

    /// Is the widget mounted?
    bool mounted2 = _sv.mounted;

    /// The StatefulWidget.
    StatefulWidget widget2 = _sv.widget;

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
