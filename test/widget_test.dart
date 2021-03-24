import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:mvc_pattern/mvc_pattern.dart';

import '../example/main.dart';

/// A flag to ensure any errors are caught when appropriate.
bool _inError = false;
String _errorMessage = '';

void main() {
  // Use a key to locate the widget you need to test
  final Key key = UniqueKey();
  _testApp(key, MyApp(key: key));
}

void _testApp(Key key, AppMVC app) {
  //
  testWidgets('test mvc_pattern', (WidgetTester tester) async {
    // Tells the tester to build a UI based on the widget tree passed to it
    await tester.pumpWidget(app);

    /// You can directly access the 'internal workings' of the app!
    final AppMVC appMVC = tester.widget(find.byKey(key));

    expect(appMVC, isInstanceOf<AppMVC>());

    final context = appMVC.context;

    expect(context, isInstanceOf<BuildContext?>());

    final con = appMVC.con;

    expect(con, isInstanceOf<AppConMVC?>());

    final ControllerMVC? controller = appMVC.controller;

    expect(controller, isInstanceOf<ControllerMVC?>());

    final init = appMVC.initAsync();

    expect(init, isInstanceOf<Future<bool>>());

    final debugging = AppMVC.inDebugger;

    expect(debugging, isInstanceOf<bool>());

    /// Test looking up State objects by id.
    final keyId = MyHomePageState().keyId;

    final map = AppMVC.getStates([keyId]);

    expect(map, isInstanceOf<Map<String, StateMVC>>());

    final list = AppMVC.listStates([keyId]);

    expect(list, isInstanceOf<List<StateMVC>>());

    /// cast the AppMVC object to type MyApp
    /// to access its unique property, home.
    // ignore: avoid_as
    final MyApp myApp = appMVC as MyApp;

    /// Returns the App's StateMVC object
    final StateMVC? stateObj = AppMVC.getState(myApp.home.stateKey!);

    expect(stateObj, isInstanceOf<StateMVC>());

    /// Tests Listener objects
    _testsListeners(stateObj);

    /// Tests StateMVC object
    await _testsStateMVC(stateObj);

    /// Tests Controller object
    _testsController(stateObj);

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

    /// Report any errors.
    _reportErrors();
  });
}

void _testsListeners(StateMVC? stateObj) {
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

Future<void> _testsStateMVC(StateMVC? stateObj) async {
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
  final id = con?.keyId;

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

  stateObj?.reassemble();

  stateObj?.deactivate();

  stateObj?.didChangeMetrics();

  stateObj?.didChangeTextScaleFactor();

  stateObj?.didChangePlatformBrightness();

//  stateObj?.didChangeLocale(locale);

//  stateObj?.didChangeAppLifecycleState(state);

  stateObj?.didHaveMemoryPressure();

  stateObj?.didChangeAccessibilityFeatures();

  stateObj?.setState(() {});

  stateObj?.refresh();
}

void _testsController(StateMVC? stateObj) {
  //
  expect(stateObj, isInstanceOf<StateMVC>());

  /// Unnecessary. Merely demonstrating an alternative to 'adding' a
  /// Controller object to a StatMVC object so to use its properties and functions.
  /// It, in fact, won't be added to the Set.
  /// Returns the unique identifier assigned to the Controller object.
  var conId = stateObj?.add(Controller());

  expect(conId, isInstanceOf<String>(), reason: 'The unique key identifier.');

  stateObj?.addList([Controller()]);

  /// Another way to retrieve its Controller from a list of Controllers
  /// Retrieve it by 'type'
  var conObj = stateObj?.controllerByType<Controller>();

  expect(conObj, isInstanceOf<Controller>());

  stateObj?.add(FakeController());

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
}

/// Record any errors for any try-catch statements.
void _catchError(Object error) {
  _inError = true;
  _errorMessage = '$_errorMessage${error.toString()} \r\n';
}

/// Throw any collected errors
void _reportErrors() {
  if (_inError) {
    throw Exception(_errorMessage);
  }
}
