# mvc_pattern
[![codecov](https://codecov.io/gh/AndriousSolutions/mvc_pattern/branch/master/graph/badge.svg)](https://codecov.io/gh/AndriousSolutions/mvc_pattern)
[![CI](https://github.com/AndriousSolutions/mvc_pattern/actions/workflows/format_then_test.yml/badge.svg)](https://github.com/AndriousSolutions/mvc_pattern/actions/workflows/format_then_test.yml)
[![Medium](https://img.shields.io/badge/Medium-Read-green?logo=Medium)](https://andrious.medium.com/a-framework-for-flutter-3a4a358f5d26/)
[![Pub.dev](https://img.shields.io/pub/v/mvc_pattern.svg?logo=data:image/png;base64,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)](https://pub.dev/packages/state_extended)
[![GitHub stars](https://img.shields.io/github/stars/AndriousSolutions/mvc_pattern.svg?style=social&amp;logo=github)](https://github.com/AndriousSolutions/mvc_pattern/stargazers)
[![Last Commit](https://img.shields.io/github/last-commit/AndriousSolutions/mvc_pattern)](https://github.com/AndriousSolutions/mvc_pattern/commits/master)
[![likes](https://badges.bar/mvc_pattern/likes)](https://pub.dev/packages/mvc_pattern/score)

Note, mvc_pattern has been rebranded, StateX. This package here is soon deprecated.

[![StateX](https://user-images.githubusercontent.com/32497443/186748251-317a3ac6-0cff-4a7d-aa39-8ecd560358a2.jpg)](https://andrious.medium.com/statex-60bc9957bf20)

## The "Kiss" of Flutter Frameworks

In keeping with the ["KISS
Principle"](https://en.wikipedia.org/wiki/KISS_principle), this is an attempt to
offer the MVC design pattern to Flutter in an intrinsic fashion incorporating
much of the Flutter framework itself. All in a standalone Flutter Package.

 In truth, this all came about only because I wanted a place to put my 'mutable' code (the business logic for the app)
 without the compiler complaining about it! Placing such code in a StatefulWidget or a StatelessWidget is discouraged of course--only immutable code should be in those objects.
 Sure, all that code could go into the State object. That's good since you want access to the State object anyway.
 After all, it's the main player when it comes to 'State Management' in Flutter. However, it makes for rather big and
 messy State objects!

 Placing the code in separate Dart files would be the solution, but then there would have to be a means to access that
 ever-important State object. I wanted the separate Dart file or files that had all the functionality and capability
 of the State object. In other words, that separate Dart file would to have access to a State object!

 Now, I had no interest in re-inventing the wheel. I wanted to keep it all Flutter, and so I stopped and looked at
 Flutter closely to see how to apply some already known design pattern onto it. That's when I saw the State
  object (its build() function specifically) as 'The View,' and the separate Dart file or files with access to that State
  object as 'The Controller.'

 This package is essentially the result, and it involves just two 'new' classes: StateMVC and ControllerMVC.
 A StateMVC object is a State object with an explicit life-cycle (Android developers will appreciate that),
  and a ControllerMVC object can be that separate Dart file with access to the State object (StateMVC in this case).
  All done with Flutter objects and libraries---no re-inventing here. It looks and tastes like Flutter.

 Indeed, it just happens to be named after the 'granddaddy' of design patterns, MVC, but it's actually a bit more like the [PAC](https://medium.com/follow-flutter/flutter-mvc-at-last-275a0dc1e730#b671)
 design pattern. In truth, you could use any other architecture you like with it. By design, you can just use the classes,
  StateMVC, and ControllerMVC. Heck! You could call objects that extend ControllerMVC, BLoC's for all that matters!
  Again, all I wanted was some means to bond a State object to separate Dart files containing the 'guts' of the app.
  I think you'll find it useful.

**Installing**

I don't always like the version number suggested in the '[Installing](https://pub.dev/packages/state_extended#-installing-tab-)' page.
Instead, always go up to the '**major**' semantic version number when installing my library packages. This means always entering a version number trailing with two zero, '**.0.0**'. This allows you to take in any '**minor**' versions introducing new features as well as any '**patch**' versions that involves bugfixes. Semantic version numbers are always in this format: **major.minor.patch**. 

1. **patch** - I've made bugfixes
2. **minor** - I've introduced new features
3. **major** - I've essentially made a new app. It's broken backwards-compatibility and has a completely new user experience. You won't get this version until you increment the **major** number in the pubspec.yaml file.

And so, in this case, add this to your package's pubspec.yaml file instead:
```javascript
dependencies:
  state_extended:^8.9.0
```
# Documentation

Turn to this free Medium article for a full overview of the package plus examples:
[![FlutterFramework](https://user-images.githubusercontent.com/32497443/149639020-0462eb7f-5711-484a-9038-251cd13d6edf.jpg)
](https://andrious.medium.com/3a4a358f5d26)

## Example Code
Copy and paste the code below to get started. Examine the paths
specified at the start of every code sequence to determine where
these files are to be located.

```dart
/// example/lib/main.dart

import 'package:example/src/view.dart';

void main() => runApp(MyApp(key: const Key('MyApp')));
```

```dart
/// example/src/app/view/my_app.dart

import 'package:example/src/view.dart';

import 'package:example/src/controller.dart';

class MyApp extends AppStatefulWidgetMVC {
  const MyApp({Key? key}) : super(key: key);

  /// This is the App's State object
  @override
  AppStateMVC createState() => _MyAppState();
}

class _MyAppState extends AppStateMVC<MyApp> {
  factory _MyAppState() => _this ??= _MyAppState._();
  static _MyAppState? _this;

  @override
  Widget buildApp(BuildContext context) => MaterialApp(
        home: FutureBuilder<bool>(
            future: initAsync(),
            builder: (context, snapshot) {
              //
              if (snapshot.hasData) {
                //
                if (snapshot.data!) {
                  /// Key identifies the widget. New key? New widget!
                  /// Demonstrates how to explicitly 're-create' a State object
                  return MyHomePage(key: UniqueKey());
                } else {
                  //
                  return const Text('Failed to startup');
                }
              } else if (snapshot.hasError) {
                //
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const Center(child: CircularProgressIndicator());
            }),
      );
}
```

```dart
/// example/src/app/controller/app_controller.dart

import 'package:example/src/view.dart';

class AppController extends ControllerMVC with AppControllerMVC {
  factory AppController() => _this ??= AppController._();
  AppController._();
  static AppController? _this;

  /// Initialize any 'time-consuming' operations at the beginning.
  /// Initialize asynchronous items essential to the Mobile Applications.
  /// Typically called within a FutureBuilder() widget.
  @override
  Future<bool> initAsync() async {
    // Simply wait for 10 seconds at startup.
    /// In production, this is where databases are opened, logins attempted, etc.
    return Future.delayed(const Duration(seconds: 10), () {
      return true;
    });
  }

  /// Supply an 'error handler' routine if something goes wrong
  /// in the corresponding initAsync() routine.
  /// Returns true if the error was properly handled.
  @override
  bool onAsyncError(FlutterErrorDetails details) {
    return false;
  }
}
```
```dart
/// example/src/home/view/my_home_page.dart

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

    /// You're able to retrieve the Controller(s) from other State objects.
    var con = appState.controller;

    con = appState.controllerByType<AppController>();

    con = appState.controllerById(con?.keyId);
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
              if (con.dataObject != null && con.dataObject is String)
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text(
                    con.dataObject as String,
                    key: const Key('greetings'),
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
          key: const Key('+'),

          /// Refresh only the Text widget containing the counter.
          onPressed: () => con.incrementCounter(),

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
```

```dart
/// example/src/home/controller/controller.dart

import 'package:example/src/view.dart';

import 'package:example/src/model.dart';

class Controller extends ControllerMVC {
  factory Controller([StateMVC? state]) => _this ??= Controller._(state);
  Controller._(StateMVC? state)
      : _model = Model(),
        super(state);
  static Controller? _this;

  final Model _model;

  /// Note, the count comes from a separate class, _Model.
  int get count => _model.counter;

  // The Controller knows how to 'talk to' the Model and to the View (interface).
  void incrementCounter() {
    //
    _model.incrementCounter();

    /// Only calls only 'SetState' widgets
    /// or widgets that called the inheritWidget(context) function
    inheritBuild();

    /// Retrieve a particular State object.
    final homeState = stateOf<MyHomePage>();

    /// If working with a particular State object and if divisible by 5
    if (homeState != null && _model.counter % 5 == 0) {
      //
      dataObject = _model.sayHello();
      setState(() {});
    }
  }

  /// Call the State object's setState() function to reflect the change.
  void onPressed() => setState(() => _model.incrementCounter());
}
```

```dart
/// example/src/view.dart

export 'package:flutter/material.dart' hide StateSetter;

export 'package:state_extended/state_extended.dart';

export 'package:example/src/app/view/my_app.dart';

export 'package:example/src/home/view/my_home_page.dart';

export 'package:example/src/home/view/page_01.dart';

export 'package:example/src/home/view/page_02.dart';

export 'package:example/src/home/view/page_03.dart';

export 'package:example/src/home/view/common/build_page.dart';
```

```dart
/// example/src/controller.dart

export 'package:example/src/app/controller/app_controller.dart';

export 'package:example/src/home/controller/controller.dart';

export 'package:example/src/home/controller/another_controller.dart';

export 'package:example/src/home/controller/yet_another_controller.dart';
```
```dart
/// example/src/model.dart

export 'package:example/src/home/model/data_source.dart';
```

Further information on the MVC package can be found in the article, [‘MVC in Flutter’](https://medium.com/follow-flutter/mvc-in-flutter-1d26b86328ea)
[![online article](https://user-images.githubusercontent.com/32497443/87216185-c626bd80-c302-11ea-9535-c5dac12ea106.png)](https://medium.com/follow-flutter/mvc-in-flutter-1d26b86328ea)
