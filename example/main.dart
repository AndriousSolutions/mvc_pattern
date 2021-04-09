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

import 'package:flutter/material.dart';

import 'package:mvc_pattern/mvc_pattern.dart';

void main() => runApp(MyApp(key: const Key('MyApp')));

/// Main or first class to pass to the 'main.dart' file's runApp() function.
class MyApp extends AppMVC {
  /// Assign a 'fake' Controller to use in Unit Testing.
  MyApp({Key? key}) : super(key: key, con: FakeAppController());

  static String? homeStateKey;

  /// Supply an 'object' to be passed all the way down the Widget tree.
  @override
  Widget build(BuildContext context) => const AppView();
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => View();
}

///
class View extends ViewMVC<AppView> {
  factory View() => _this ??= View._();

  /// Demonstrate passing an 'object' down the Widget tree
  /// like in the Scoped Model
  View._()
      : super(
          controller: FakeAppController(),
          object: const Text(
            'Hello World!',
            style: TextStyle(color: Colors.red),
          ),
        );
  static View? _this;

  /// Allow for external access to is object.
  static View? get instance => _this;

  @override
  Widget buildApp(BuildContext context) => MaterialApp(
          home: MyHomePage(
        key: const Key('MyHomePage'),
        title: 'MVC Pattern Demo',
      ));

  /// Supply an error handler for Unit Testing.
  @override
  void onError(FlutterErrorDetails details) {
    /// Error is now handled.
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title = 'Flutter Demo'}) : super(key: key) {
    /// Creating a ambiguous StateMVC object merely for testing purposes.
    SecondState();
  }
  // Fields in a StatefulWidget should always be "final".
  final String title;

  @override
  // ignore: no_logic_in_create_state
  State createState() => MyHomePageState();
}

/// The State object is extended by its 'MVC version', StateMVC.
class MyHomePageState extends StateMVC<MyHomePage> {
  MyHomePageState() : super(Controller()) {
    /// Acquire a reference to the particular Controller.
    con = controller as Controller;

    /// For Unit testing. Adding a listener object to this State object.
    final listener = ListenTester();
    addAfterListener(listener);
    addBeforeListener(listener);
  }
  late Controller con;

  @override
  void initState() {
    super.initState();

    /// Testing the Controller's initState();
    con.initState();

    /// For testing purposes, supply this StateMVC object's unique identifier
    /// to its StatefulWidget.
    MyApp.homeStateKey = keyId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SetState(builder: (context, obj) {
              Widget widget = const SizedBox(height: 5);
              if (obj is Text) {
                widget = obj;
              }
              return widget;
            }),
            const Text('You have pushed the button this many times:'),
            Text(
              '${con.counter}',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(con.incrementCounter);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Supply an error handler for Unit Testing.
  @override
  void onError(FlutterErrorDetails details) {
    /// Error is now handled.
  }
}

class Controller extends ControllerMVC {
  factory Controller([StateMVC? state]) => _this ??= Controller._(state);
  Controller._(StateMVC? state) : super(state);
  static Controller? _this;

  late _Model _model;

  @override
  void initState() {
    _model = _Model(stateMVC);
  }

  int get counter => _model.counter;
  // The Controller knows how to 'talk to' the Model.
  void incrementCounter() => _model._incrementCounter();
}

class _Model extends ModelMVC {
  _Model([StateMVC? state]) : super(state);

  int get counter => _counter;
  int _counter = 0;
  int _incrementCounter() => ++_counter;
}

class ListenTester with StateListener {
  factory ListenTester() => _this ??= ListenTester._();
  ListenTester._();
  static ListenTester? _this;

  /// Initialize any 'time-consuming' operations at the beginning.
  /// Initialize asynchronous items essential to the Mobile Applications.
  /// Typically called within a FutureBuilder() widget.
  @override
  Future<bool> initAsync() async => true;

  /// Supply an 'error handler' routine if something goes wrong
  /// in the corresponding initAsync() routine.
  /// Returns true if the error was properly handled.
  @override
  bool onAsyncError(FlutterErrorDetails details) {
    return false;
  }

  /// The framework will call this method exactly once.
  /// Only when the [StateMVC] object is first created.
  @override
  void initState() {}

  /// The framework calls this method whenever it removes this [StateMVC] object
  /// from the tree.
  @override
  void deactivate() {}

  /// The framework calls this method when this [StateMVC] object will never
  /// build again.
  /// Note: THERE IS NO GUARANTEE THIS METHOD WILL RUN in the Framework.
  @override
  void dispose() {
    super.dispose();
  }

  // ignore: comment_references
  /// Override this method to respond when the [widget] changes (e.g., to start
  /// implicit animations).
  @override
  void didUpdateWidget(StatefulWidget oldWidget) {}

  /// Called when a dependency of this [StateMVC] object changes.
  @override
  void didChangeDependencies() {}

  /// Called whenever the application is reassembled during debugging, for
  /// example during hot reload.
  @override
  void reassemble() {}

  /// Called when the system tells the app to pop the current route.
  /// For example, on Android, this is called when the user presses
  /// the back button.
  @override
  Future<bool> didPopRoute() async => true;

  /// Called when the host tells the app to push a new route onto the
  /// navigator.
  @override
  Future<bool> didPushRoute(String route) async => true;

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  @override
  void didChangeMetrics() {}

  /// Called when the platform's text scale factor changes.
  @override
  void didChangeTextScaleFactor() {}

  /// Brightness changed.
  @override
  void didChangePlatformBrightness() {}

  /// Called when the system tells the app that the user's locale has changed.
  @override
  void didChangeLocale(Locale locale) {}

  /// Called when the system puts the app in the background or returns the app to the foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  /// Called when the system is running low on memory.
  @override
  void didHaveMemoryPressure() {}

  /// Called when the system changes the set of active accessibility features.
  @override
  void didChangeAccessibilityFeatures() {}
}

/// A fake StateMVC object for testing purposes.
class SecondState extends StateMVC<MyHomePage> {
  factory SecondState() => _this ??= SecondState._();

  /// Pass 'null' to test the Controller with a null State object.
  SecondState._() : super(Controller(null));
  static SecondState? _this;

  @override
  Widget build(BuildContext context) => const Center();
}

/// A fake Controller object for testing purposes.
class FakeController extends ControllerMVC {
  factory FakeController() => _this ??= FakeController._();
  FakeController._();
  static FakeController? _this;
}

/// A fake 'App' Controller object for testing purposes.
class FakeAppController extends AppConMVC {
  factory FakeAppController() => _this ??= FakeAppController._();
  FakeAppController._();
  static FakeAppController? _this;

  /// Supply an error handler for Unit Testing.
  @override
  void onError(FlutterErrorDetails details) {
    super.onError(details);

    /// Error is now handled.
  }
}
