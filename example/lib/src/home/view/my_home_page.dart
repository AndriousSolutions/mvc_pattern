// Copyright 2022 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:example/src/view.dart';

import 'package:example/src/controller.dart';

/// The Home page
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title = 'Flutter Demo'}) : super(key: key);

  // Fields in a StatefulWidget should always be "final".
  final String title;

  @override
  State createState() => _MyHomePageState();
}

/// This 'MVC version' is a subclass of the State class.
/// This version is linked to the App's lifecycle using [WidgetsBindingObserver]
class _MyHomePageState extends StateMVC<MyHomePage> {
  /// Let the 'business logic' run in a Controller
  _MyHomePageState() : super(Controller()) {
    /// Acquire a reference to the passed Controller.
    con = controller as Controller;
  }
  late Controller con;

  @override
  void initState() {
    /// Look inside the parent function and see it calls
    /// all it's Controllers if any.
    super.initState();

    /// Retrieve the 'app level' State object
    appState = rootState!;

    /// By the way, when necessary, you can retrieve
    /// a State object's many Controllers as well.
    final con = appState.controllerByType<AppController>();

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
              /// Display the App's data object if it has something to display
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
              // Text(
              //   '${con.count}',
              //   style: Theme.of(context).textTheme.headline4,
              // ),
              SetState(
                builder: (context, dataObject) => Text(
                  '${con.count}',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          /// Refresh only the Text widget containing the counter.
          onPressed: () {
            con.incrementCounter();

            /// Only calls only 'SetState' widgets
            inheritBuild();
          },

          /// The traditional approach calling the State object's setState() function.
          // onPressed: () {
          //   setState(con.incrementCounter);
          // },
          /// You can have the Controller called the interface (the View).
//          onPressed: con.onPressed,
          child: const Icon(Icons.add),
        ),
      );

  /// Supply an error handler for Unit Testing.
  @override
  void onError(FlutterErrorDetails details) {
    /// Error is now handled.
    super.onError(details);
  }
}
