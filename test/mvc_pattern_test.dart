import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:mvc_pattern/mvc_pattern.dart';

import 'counter_app_test.dart' as one;
import 'counter_app_test2.dart' as two;
import 'counter_app_test3.dart' as three;
import 'counter_app_test4.dart' as four;
import 'counter_app_test5.dart' as five;

void main() {
  // Use a key to locate the widget you need to test
  Key key = UniqueKey();
  _testApp(key, one.MyApp(key: key));
  key = UniqueKey();
  _testApp(key, two.MyApp(key: key));
  key = UniqueKey();
  _testApp(key, three.MyApp(key: key));
  key = UniqueKey();
  _testApp(key, four.MyApp(key: key));
  key = UniqueKey();
  _testApp(key, five.MyApp(key: key));
}

void _testApp(Key key, AppMVC app) {
  testWidgets('Counter App Test', (WidgetTester tester) async {
    // Tells the tester to build a UI based on the widget tree passed to it
    await tester.pumpWidget(app);

    /// You can directly access the 'internal workings' of the app!
    final widget = tester.widget(find.byKey(key));

    expect(widget, isInstanceOf<AppMVC>());

    // ignore: avoid_as
    final AppMVC appObj = widget as AppMVC;

    /// Reference to the Controller.
    final ControllerMVC? con = appObj.controller;

    if (con != null) {
      expect(con, isInstanceOf<ControllerMVC>());

      /// Reference to the StateMVC.
      final _sv = con.stateMVC!;

      expect(_sv, isInstanceOf<State<StatefulWidget>>());

      /// The State object.
      final _state = con.stateMVC;

      expect(_state, isInstanceOf<State<StatefulWidget>>());

      /// Controller's unique identifier.
      final id = con.keyId;

      expect(id, isInstanceOf<String>());

      /// The StateView's unique identifier.
      final svId = _sv.keyId;

      expect(svId, isInstanceOf<String>());

      /// Current context.
      final context2 = _sv.context;

      expect(context2, isInstanceOf<BuildContext>());

      /// Is the widget mounted?
      final mounted2 = _sv.mounted;

      expect(mounted2, isInstanceOf<bool>());

      /// The StatefulWidget.
      final widget2 = _sv.widget;

      expect(widget2, isInstanceOf<StatefulWidget>());
    }

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    /// You can access the Controller's properties.
//    expect(con.displayThis == 1, true);

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
