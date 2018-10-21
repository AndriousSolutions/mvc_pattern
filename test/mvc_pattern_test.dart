import 'package:flutter/material.dart';

//import 'package:test/test.dart'; // Not acceptable to pub package.
import 'package:flutter_test/flutter_test.dart';

import 'package:mvc_pattern/mvc_pattern.dart';

import 'counter_app_test.dart';

void main() {

  testWidgets('Header adds todo', (WidgetTester tester) async {
    // Use a key to locate the widget you need to test
    Key key = UniqueKey();

    // Tells the tester to build a UI based on the widget tree passed to it
    await tester.pumpWidget(
        MaterialApp(
          title: 'MVC Testing',
          home: MyHomePage(key: key),
        ));

    /// You can directly access the 'internal workings' of the app!
    StatefulWidgetMVC _sw = tester.widget(find.byKey(key));

    /// Look! You've got a reference a state.
    StateViewMVC _sv = _sw.state;

    /// Look! You've got a reference the view.
    ViewMVC _view = _sv.view;

    /// Look! You've got a reference the controller.
    Controller _con = _view.controller;

    /// Look! You can even get a reference to the build() function's returning widget.
    Widget _widget = _sv.buildWidget;

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    /// You can access the Controller's properties.
    expect(_con.displayThis == 1, true);

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}