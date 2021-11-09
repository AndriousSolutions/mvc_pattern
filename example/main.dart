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

/// Used to import the Timer class
import 'dart:async';

// Flutter's Material Interface package
import 'package:flutter/material.dart';

// The framework package
import 'package:mvc_pattern/mvc_pattern.dart';

void main() => runApp(MyApp(key: const Key('MyApp')));

/// Main or first class to pass to the 'main.dart' file's runApp() function.
/// This is the app's StatefulWidget.
class MyApp extends AppStatefulWidgetMVC {
  MyApp({Key? key}) : super(key: key, con: AnotherController());

  /// For testing purposes, supply this StatefulWidget its State object's unique identifier
  static String? homeStateKey;

  /// The app's State object is named, View.
  /// Name yours whatever you want.
  @override
  AppStateMVC createState() => View();
}

///
class View extends AppStateMVC<MyApp> {
  factory View() => _this ??= View._();

  /// Demonstrate passing an 'object' down the Widget tree
  /// much like in the Scoped Model
  View._() : super(controller: AnotherController());
  static View? _this;

  /// Optionally you can is the framework's buildApp() function
  /// instead of its build() function.
  /// Allows for the InheritWidget feature
  @override
  Widget buildApp(BuildContext context) => const MaterialApp(
        home: MyHomePage(
          key: Key('MyHomePage'),
          title: 'MVC Design Pattern Demo App',
        ),
      );
}

/// The Home page
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title = 'Flutter Demo'}) : super(key: key);

  // Fields in a StatefulWidget should always be "final".
  final String title;

  @override
  State createState() => MyHomePageState();
}

/// This 'MVC version' is a subclass of the usual State<StatefulWidget>
/// It allows you to handle all the 'events' that routinely occur on a running device
class MyHomePageState extends StateMVC<MyHomePage> {
  /// Free up your State objects and handle the 'business logic' in a Controller
  MyHomePageState() : super(Controller()) {
    /// Acquire a reference to the particular Controller.
    con = controller as Controller;
  }
  late Controller con;

  @override
  void initState() {
    super.initState();

    /// Retrieve the 'app level' State object
    appState = AnotherController().ofState<View>()!;

    /// For testing purposes, supply this StateMVC object's unique identifier
    /// to its StatefulWidget.
    MyApp.homeStateKey = keyId;
  }

  late AppStateMVC appState;

  /// This is 'the View'; the interface of the home page.
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Display the App's data object if it has something to display
              if (appState.dataObject != null && appState.dataObject is String)
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text(
                    appState.dataObject as String,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: Theme.of(context).textTheme.headline4!.fontSize,
                    ),
                  ),
                ),
              Text(
                'You have pushed the button this many times:',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Text(
                '${con.count}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(con.incrementCounter);
          },

          /// You can separate further the roles of work between the controller and interface
//          onPressed: con.onPressed,
          child: const Icon(Icons.add),
        ),
      );

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
    super.initState();
    _model = _Model(state);
  }

  /// Note, the count comes from a separate class, _Model.
  int get count => _model.counter;

  // The Controller knows how to 'talk to' the Model.
  void incrementCounter() {
    _model._incrementCounter();

    /// At thr count of 20, say hello.
    if (_model.counter == 20) {
      /// Retrieve the 'app level' State object
      final appState = AnotherController().ofState<View>()!;
      appState.dataObject = 'Hello there!';
    }
  }

  /// Call the State object's setState() function to reflect the change.
  void onPressed() => setState(() => _model._incrementCounter());
}

/// This separate class represents 'the Model' (the data) of the App.
class _Model extends ModelMVC {
  factory _Model([StateMVC? state]) => _this ??= _Model._(state);
  _Model._(StateMVC? state) : super(state);
  static _Model? _this;

  int get counter => _counter;
  int _counter = 0;
  int _incrementCounter() => ++_counter;
}

class AnotherController extends ControllerMVC with AppControllerMVC {
  factory AnotherController() => _this ??= AnotherController._();
  AnotherController._();
  static AnotherController? _this;

  /// The framework will call this method exactly once.
  /// Only when the [StateMVC] object is first created.
  @override
  void initState() {
    super.initState();
    //ignore: avoid_print
    print('didUpdateWidget');
  }

  /// The framework calls this method whenever it removes this [StateMVC] object
  /// from the tree.
  @override
  void deactivate() {
    //ignore: avoid_print
    print('didUpdateWidget');
  }

  /// The framework calls this method when this [StateMVC] object will never
  /// build again.
  /// Note: THERE IS NO GUARANTEE THIS METHOD WILL RUN in the Framework.
  @override
  void dispose() {
    super.dispose();
    //ignore: avoid_print
    print('didUpdateWidget');
  }

  /// Override this method to respond when the [widget] changes (e.g., to start
  /// implicit animations).
  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    //ignore: avoid_print
    print('didUpdateWidget');
  }

  /// Called when a dependency of this [StateMVC] object changes.
  @override
  void didChangeDependencies() {
    //ignore: avoid_print
    print('didUpdateWidget');
  }

  /// Called whenever the application is reassembled during debugging, for
  /// example during hot reload.
  @override
  void reassemble() {
    //ignore: avoid_print
    print('didUpdateWidget');
  }

  /// Called when the system tells the app to pop the current route.
  /// For example, on Android, this is called when the user presses
  /// the back button.
  @override
  Future<bool> didPopRoute() async {
    //ignore: avoid_print
    print('didUpdateWidget');
    return true;
  }

  /// Called when the host tells the app to push a new route onto the
  /// navigator.
  @override
  Future<bool> didPushRoute(String route) async {
    //ignore: avoid_print
    print('didUpdateWidget');
    return true;
  }

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  @override
  void didChangeMetrics() {
    //ignore: avoid_print
    print('didChangeMetrics');
  }

  /// Called when the platform's text scale factor changes.
  @override
  void didChangeTextScaleFactor() {
    //ignore: avoid_print
    print('didChangeTextScaleFactor');
  }

  /// Brightness changed.
  @override
  void didChangePlatformBrightness() {
    //ignore: avoid_print
    print('didChangePlatformBrightness');
  }

  /// Called when the system tells the app that the user's locale has changed.
  @override
  void didChangeLocale(Locale locale) {
    //ignore: avoid_print
    print('didChangeLocale');
  }

  /// Called when the system puts the app in the background or returns the app to the foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Passing these possible values:
    /// AppLifecycleState.paused (may enter the suspending state at any time)
    /// AppLifecycleState.resumed
    /// AppLifecycleState.inactive (may be paused at any time)
    /// AppLifecycleState.suspending (Android only)
    //ignore: avoid_print
    print('didChangeAppLifecycleState');
  }

  /// Called when the system is running low on memory.
  @override
  void didHaveMemoryPressure() {
    //ignore: avoid_print
    print('didHaveMemoryPressure');
  }

  /// Called when the system changes the set of active accessibility features.
  @override
  void didChangeAccessibilityFeatures() {
    //ignore: avoid_print
    print('didChangeAccessibilityFeatures');
  }
}
